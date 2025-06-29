# Выбираем вариант с использованием service_account_id (как у вас указано в комментариях)
data "yandex_iam_service_account" "andyan_sa" {
  service_account_id = "ajecikr0epkc7nnrh0cg" # Используем только ID
}

# Альтернативный вариант (если предпочтете использовать имя)
# data "yandex_iam_service_account" "andyan_sa" {
#   name      = "andyan"
#   folder_id = var.folder_id # Используем переменную из variables.tf
# }