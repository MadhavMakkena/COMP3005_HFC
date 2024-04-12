erDiagram
    USERS ||--o{ ANNOUNCEMENTS : "has"
    ANNOUNCEMENTS ||--|| USERS : "belong to"
    USERS ||--o{ PAYMENTS : "makes"
    USERS ||--o{ HEALTH_METRICS : "records"
    USERS ||--o{ MEMBER_SESSIONS : "participates"
    USERS ||--o{ TRAINING_SESSIONS : "registers"
    TRAINING_SESSIONS ||--o{ MEMBER_SESSIONS : "includes"
    TRAINING_SESSIONS }|--|| ROOM_BOOKINGS : "books"
    USERS ||--o{ REMINDERS : "set"
    USERS ||--o{ EQUIPMENT : "verify"


    ANNOUNCEMENTS {
        bigint id PK
        varchar title
        text content
        integer for_user_type
        bigint user_id FK
    }
    USERS {
        bigint id PK
        varchar first_name
        varchar last_name
        varchar email
        integer role
        date date_of_birth
    }
    PAYMENTS {
        bigint id PK
        bigint user_id FK
        date payment_date
    }
    HEALTH_METRICS {
        bigint id PK
        bigint user_id FK
        numeric height
        numeric weight
        numeric bmi
        integer hydration
    }
    MEMBER_SESSIONS {
        bigint id PK
        bigint user_id FK
        bigint training_session_id FK
    }
    ROOM_BOOKINGS {
        bigint id PK
        integer room_name
        text location
        timestamp booking_time
    }
    TRAINING_SESSIONS {
        bigint id PK
        bigint user_id FK
        bigint room_booking_id FK
    }
    EQUIPMENT {
        bigint id PK
        varchar name
        varchar description
        integer location
        boolean is_broken
    }
    REMINDERS {
        bigint id PK
        varchar title
        text content
        timestamp due_date
        boolean completed
    }
