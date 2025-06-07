package notice.project.core;

import org.sqlite.SQLiteConfig;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

public class ServiceHandler implements InvocationHandler {

    private final Object targetServiceInstance; // 실제 서비스 구현 객체의 인스턴스
    private final String dbUrl = "jdbc:sqlite:" + System.getenv("database");
    // 서비스 생성 시 주입된 리포지토리 인스턴스들을 관리 (인터페이스 타입, 실제 인스턴스)
    private final Map<Class<?>, Object> serviceOwnedRepositories = new HashMap<>();
    // 리포지토리 인터페이스와 그 구현체 클래스 매핑 정보 (외부에서 주입)


    public ServiceHandler(Class<?> targetServiceClass) {
        try {
            // 1. targetServiceClass에서 사용할 생성자 찾기 (예: 가장 파라미터가 많은 public 생성자)
            Constructor<?> constructorToUse = findSuitableConstructor(targetServiceClass);
            constructorToUse.setAccessible(true);

            Class<?>[] constructorParamTypes = constructorToUse.getParameterTypes();
            Object[] constructorArgs = new Object[constructorParamTypes.length];

            // 2. 생성자 파라미터 타입에 따라 리포지토리 인스턴스 생성 (Connection 없이)
            for (int i = 0; i < constructorParamTypes.length; i++) {
                Class<?> repoClass = constructorParamTypes[i];

                // 리포지토리 구현체의 기본 생성자로 인스턴스 생성
                Constructor<?> repoConstructor = repoClass.getDeclaredConstructor(); // 기본 생성자 필요
                repoConstructor.setAccessible(true);
                Object repoInstance = repoConstructor.newInstance();

                constructorArgs[i] = repoInstance;
                this.serviceOwnedRepositories.put(repoClass, repoInstance); // 관리 목록에 추가
            }

            // 3. 준비된 리포지토리 인스턴스들로 targetService 인스턴스 생성
            this.targetServiceInstance = constructorToUse.newInstance(constructorArgs);

        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize ServiceHandler for " + targetServiceClass.getName(), e);
        }
    }

    private Constructor<?> findSuitableConstructor(Class<?> targetServiceClass) {
        return Arrays.stream(targetServiceClass.getDeclaredConstructors())
                .filter(c -> Modifier.isPublic(c.getModifiers())) // public 생성자 중
                .max(Comparator.comparingInt(Constructor::getParameterCount)) // 파라미터 가장 많은 것
                .orElseThrow(() -> new RuntimeException("No suitable public constructor found for " + targetServiceClass.getName()));
    }


    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Exception {
        Method actualMethod;
        try {
            // 실제 실행될 메서드는 targetServiceInstance의 구현 클래스에 있는 메서드
            actualMethod = targetServiceInstance.getClass().getMethod(method.getName(), method.getParameterTypes());
        } catch (NoSuchMethodException e) {
            return method.invoke(targetServiceInstance, args); // 인터페이스 메서드 직접 호출 (방어)
        }

        Transactional transactionalAnnotation = actualMethod.getAnnotation(Transactional.class);

        if (transactionalAnnotation == null) {
            return actualMethod.invoke(targetServiceInstance, args); // 트랜잭션 없이 바로 호출
        }

        Connection conn = null;
        Object result = null;
        Class.forName("org.sqlite.JDBC");

        try {
            SQLiteConfig config = new SQLiteConfig();
            config.enforceForeignKeys(true);
            conn = DriverManager.getConnection(dbUrl, config.toProperties());
            conn.setAutoCommit(false);

            // 1. 서비스가 소유한 리포지토리 인스턴스들에 Connection 주입
            for (Object repoInstance : this.serviceOwnedRepositories.values()) {
                // 리포지토리 인스턴스에 setConnection(Connection) 메서드가 있다고 가정
                Method setConnectionMethod = repoInstance.getClass().getMethod("setConnection", Connection.class);
                setConnectionMethod.invoke(repoInstance, conn);
            }

            // 2. 실제 타겟 서비스 메서드 호출
            result = actualMethod.invoke(targetServiceInstance, args);

            conn.commit();

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); System.err.println("트랜잭션 롤백됨: " + actualMethod.getName()); }
                catch (SQLException ex) { System.err.println("롤백 실패: " + ex.getMessage()); }
            }
            Exception cause = e;
            if (e instanceof java.lang.reflect.InvocationTargetException) {
                cause = (Exception) ((java.lang.reflect.InvocationTargetException) e).getTargetException();
            }
            throw cause;
        } finally {
            // 3. 리포지토리 인스턴스들에서 Connection 해제 및 DB 연결 닫기
            for (Object repoInstance : this.serviceOwnedRepositories.values()) {
                try {
                    Method setConnectionMethod = repoInstance.getClass().getMethod("setConnection", Connection.class);
                    setConnectionMethod.invoke(repoInstance, (Connection) null); // null로 Connection 해제
                } catch (Exception ex) {
                    System.err.println("리포지토리에서 Connection 해제 실패 ("+ repoInstance.getClass().getSimpleName() +"): " + ex.getMessage());
                }
            }

            if (conn != null) {
                try {
                    if (!conn.getAutoCommit()) conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    System.err.println("DB 연결 닫기 실패: " + ex.getMessage());
                }
            }
        }
        return result;
    }
}