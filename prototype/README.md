#IpMan Prototype (simple version)

##User

- C: 在 `User` 的 `sign-up-page`
  - 所需資訊：
    - `user_email`
    - `user_password`
    - `user_confirm_password`

- R: 在 `admin` 的 `management-page`
  - 所需資訊：
    - `user_id`
    - `user_email`
    - `user_role`
    - `user_created_at`
    - `user_updated_at`

- U: `User` 的 `role` 可分為 `member` 或是 `admin`
  - member: 在 `User` 的 `edit-page`
    - 所需資訊：
      - `user_new_password`
      - `user_confirm_new_password`
      - `user_current_password`
  - admin: 在 `admin` 的 `management-page`
    - `admin` 僅可更新每個 users 的 `role`

- D: 在 `admin` 的 `management-page` 可以進行刪除 users 的動作

##Task

- C: 在 `Task` 的 `new-page`
  - 所需資訊：
    - `task_title`
    - `task_started_at`
    - `task_deadline_at`
    - `task_emergency_level`
    - `task_status`
    - `task_description`

- R: 在 `Task` 的 `index-page`
  - 所需資訊：
    - `task_title`
    - `task_started_at`
    - `task_deadline_at`
    - `task_emergency_level`
    - `task_description`

- U: 在 `Task` 的 `edit-page`
  - 所需資訊與 `Task` 的 C 相同

- D: 在 `Task` 的 `index-page` 可以進行刪除 tasks 的動作

##Tag

- C: 在 `Task` 的 `new-page` & `edit-page`
  - 所需資訊：
    - `tag_name`

- R: 在 `Task` 的 `index-page`
  - 所需資訊：
    - `tag_name`

- U: 在 `Task` 的 `edit-page`
  - 所需資訊與 `Tag` 的 C 相同

- D: 在 `Task` 的 `new-page` & `edit-page` 都可以進行刪除 tags 的動作