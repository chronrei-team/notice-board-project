package notice.project.core;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME) // 런타임에 리플렉션으로 어노테이션 정보를 읽을 수 있도록 설정
@Target(ElementType.METHOD)         // 메서드에만 적용 가능하도록 설정
public @interface Authorization { }