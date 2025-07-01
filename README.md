# yc-terraform-swarm
## Описание инфраструктуры как кода (IaC)

Инфраструктура интернет-магазина носков включает:

### 1. **Сеть и подсеть**
- VPC сеть `swarm-network`
- Подсеть `192.168.10.0/24` в зоне `ru-central1-d`
- Статический публичный IP для manager-ноды

### 2. **Виртуальные машины**
```hcl
resource "yandex_compute_instance" "swarm_manager" {
  resources {
    cores  = 2
    memory = 2
  }
  # ... другие параметры ...
}
```
- 1 manager-нода (2 vCPU, 2GB RAM)
- 2 worker-ноды (2 vCPU, 2GB RAM)

### 3. **Docker Swarm кластер**
```bash
# Автоматическая инициализация
docker swarm init --advertise-addr 192.168.10.10

# Присоединение worker-нод
docker swarm join --token <TOKEN> 192.168.10.10:2377
```

### 4. **Сервисы приложения**
| Сервис          | Образ                          | Порт  | Реплики |
|-----------------|--------------------------------|-------|---------|
| front-end       | weaveworksdemos/front-end      | 30000 | 2       |
| catalogue       | weaveworksdemos/catalogue      | -     | 1       |
| carts           | weaveworksdemos/carts          | -     | 1       |

## Файловая структура проекта

```
.
├── authorized_key.json      # Ключ сервисного аккаунта
├── data.tf                  # Data-источники
├── docker-compose-v3.yml    # Конфигурация Docker Stack
├── instances.tf             # Конфигурация ВМ
├── network.tf               # Конфигурация сети
├── outputs.tf               # Output-переменные
├── provider.tf              # Провайдеры Terraform
├── provisioning.tf          # Настройка кластера
├── service-account.tf       # Сервисный аккаунт
└── variables.tf             # Переменные
```

## Примеры команд для проверки

### 1. Проверить список нод
```bash
docker node ls
```
Пример вывода:
```
ID                            HOSTNAME       STATUS    AVAILABILITY   MANAGER STATUS
x12b3... *    swarm-manager   Ready     Active         Leader
a34c5...      swarm-worker-1  Ready     Active  
b56d7...      swarm-worker-2  Ready     Active
```

### 2. Проверить сервисы
```bash
docker service ls
```
Пример вывода:
```
ID             NAME                MODE        REPLICAS  IMAGE
k89lm...       sockshop_front-end  replicated  2/2       weaveworksdemos/front-end
```

### 3. Проверить логи сервиса
```bash
docker service logs sockshop_front-end --tail 20
```

### 4. Масштабировать сервис
```bash
docker service scale sockshop_front-end=3
```

### 5. Проверить сетевые подключения
```bash
docker network ls
docker network inspect sockshop_default
```