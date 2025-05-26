package notice.project.core;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;

public class ServiceFactory {
    @SuppressWarnings("unchecked")
    public static <T> T createProxy(
            Class<T> interfaceType,                      // 서비스 인터페이스
            Class<? extends T> targetImplClass          // 서비스 실제 구현 클래스
    ) {
        return (T) Proxy.newProxyInstance(
                interfaceType.getClassLoader(),
                new Class<?>[]{interfaceType},
                new ServiceHandler(targetImplClass) // ServiceHandler에 구현 클래스 타입 전달
        );
    }
}
