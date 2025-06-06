-- SQLite 테이블 생성 구문 (카멜 케이스 컬럼명)

-- 외래 키 제약 조건 활성화 (각 연결마다 실행 필요)
PRAGMA foreign_keys = ON;

-- users 테이블
CREATE TABLE users (
    id TEXT PRIMARY KEY,                         -- UUID, 문자열로 저장
    passwordHash TEXT NOT NULL,                  -- 비밀번호 암호화
    createdAt TEXT NOT NULL,                     -- 계정 생성 시간 (ISO8601 형식 권장: 'YYYY-MM-DD HH:MM:SS.SSS')
    updatedAt TEXT,                     		 -- 계정 정보 수정 시간 (ISO8601 형식 권장)
    lastLoginAt TEXT,                            -- 마지막 로그인 시간 (ISO8601 형식 권장)
    deletedAt TEXT,                              -- 탈퇴 시간 (ISO8601 형식 권장)
    status TEXT NOT NULL,                        -- 계정 상태
    userName TEXT NOT NULL UNIQUE,               -- 닉네임
    role TEXT NOT NULL                           -- 권한
);

-- users 테이블 인덱스 (컬럼명도 카멜 케이스로 변경)
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_createdAt ON users(createdAt);
CREATE INDEX idx_users_userName ON users(userName);


-- posts 테이블
CREATE TABLE posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId TEXT NOT NULL,                        -- 유저 id (users.id 참조)
    title TEXT NOT NULL,                         -- 제목
    content TEXT NOT NULL,                       -- 본문
    createdAt TEXT NOT NULL,                     -- 작성 시간 (ISO8601 형식 권장)
    updatedAt TEXT,                     		 -- 수정 시간 (ISO8601 형식 권장)
    viewCount INTEGER DEFAULT 0,                 -- 조회수
    recommendCount INTEGER DEFAULT 0,            -- 추천수
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- posts 테이블 인덱스
CREATE INDEX idx_posts_userId_createdAt ON posts(userId, createdAt);
CREATE INDEX idx_posts_createdAt ON posts(createdAt);


-- post_files 테이블
CREATE TABLE post_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    postId INTEGER NOT NULL,                     -- 게시글 id (posts.id 참조)
    name TEXT NOT NULL,                          -- 원본 파일 이름
    url TEXT NOT NULL,                           -- 위치
    fileType TEXT NOT NULL,                      -- 타입 (이미지, 비디오 등)
    uploadedAt TEXT NOT NULL,                    -- 업로드 시간 (ISO8601 형식 권장)
    FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- post_files 테이블 인덱스
CREATE INDEX idx_post_files_postId ON post_files(postId);


-- comments 테이블
CREATE TABLE comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    postId INTEGER NOT NULL,                     -- 게시글 id (posts.id 참조)
    parentCommentId INTEGER,                     -- 부모 댓글 id (comments.id 참조, NULL 가능)
    referenceCommentUserId TEXT,                 -- 참조 댓글 작성자 (users.id 참조, NULL 가능)
    userId TEXT NOT NULL,                        -- 작성자 (users.id 참조)
    content TEXT NOT NULL,                       -- 내용
    createdAt TEXT NOT NULL,                     -- 작성 시간 (ISO8601 형식 권장)
    FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (parentCommentId) REFERENCES comments(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (referenceCommentUserId) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- comments 테이블 인덱스
CREATE INDEX idx_comments_postId ON comments(postId);
CREATE INDEX idx_comments_userId ON comments(userId);
CREATE INDEX idx_comments_parentCommentId ON comments(parentCommentId);
CREATE INDEX idx_comments_createdAt ON comments(createdAt);


-- comment_images 테이블
CREATE TABLE comment_images (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    commentId INTEGER NOT NULL,                  -- 댓글 id (comments.id 참조)
    name TEXT NOT NULL,                          -- 원본 파일 이름
    url TEXT NOT NULL,                           -- 저장 경로
    uploadedAt TEXT NOT NULL,                    -- 업로드 시간 (ISO8601 형식 권장)
    FOREIGN KEY (commentId) REFERENCES comments(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- comment_images 테이블 인덱스
CREATE INDEX idx_comment_images_commentId ON comment_images(commentId);