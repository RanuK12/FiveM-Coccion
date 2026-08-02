# 🍳 FiveM-Coccion — Sistema de Cocina Profesional

FiveM resource premium para sistema de cocina avanzado con soporte multi-framework (ESX y QB-Core), diseñado para servidores RolePlay que buscan inmersión y realismo en sus experiencias culinarias.

---

## ✨ Características Principales

### 🎮 Soporte Multi-Framework
- **ESX Framework** — Compatibilidad total con es_extended y derivados
- **QB-Core Framework** — Integración con qb-core y sus modificaciones
- Auto-detección del framework activo
- Sin necesidad de modificar código base

### 🍳 Sistema de Cocina Avanzado
- **Sistema de niveles y experiencia** — Los jugadores mejoran sus habilidades culinarias
- **7 recetas únicas** — Desde platos básicos hasta comidas gourmet
- **Progresión con multiplicador** — A mayor nivel, más experiencia se obtiene por cocción
- **Requisitos de trabajo** — Recetas avanzadas requieren ser chef con cierto rango

### 🎨 Efectos Visuales
- **Blips en el mapa** en 3 ubicaciones de cocina
- **Marcadores 3D animados** (cian, rotación, movimiento vertical)
- **Partículas** — Humo y fuego durante la cocción, burst al completar
- **Animaciones realistas** de preparación de alimentos
- **Help text** contextual al acercarse a una cocina

### 🛡️ Anti-Cheat
- **Control de distancia** — El jugador debe estar cerca de un marcador de cocina
- **Cooldown entre cocciones** — Previene spam (configurable en ms)
- **Verificación server-side de ingredientes** — No se puede cocinar sin los items reales
- **Logging de intentos de trampa** vía Discord webhook

### 🔧 Configuración Extensa
- Recetas editables en `config.lua`
- Sistema de notificaciones personalizable
- Webhook de Discord para logs (cocciones, level-ups, cheat attempts)
- Progresión ajustable (exp por nivel, tiempo de cocción)
- Traducciones completas (ES/EN)

---

## 📋 Requisitos

| Requisito | Versión | Obligatorio |
|-----------|---------|-------------|
| ESX Framework | 1.2+ | Sí (si usás ESX) |
| QB-Core Framework | 3.0+ | Sí (si usás QB) |
| ox_lib | 3.0+ | No (recomendado para progress bar) |
| Sistema de inventario | — | Sí |
| Sistema de jobs | — | Solo para recetas de chef |

---

## 🚀 Instalación

1. Descargá el `.zip` de Tebex
2. Extraé la carpeta y renombrala a `coccion`
3. Copiala en `resources/` de tu servidor FiveM
4. Agregá `ensure coccion` a tu `server.cfg`
5. Ejecutá el SQL en tu base de datos:

```sql
CREATE TABLE IF NOT EXISTS coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);
```

6. Editá `config.lua` (framework, webhook de Discord, coordenadas de cocinas, recetas)
7. Reiniciá el servidor

---

## 🍽️ Recetas Incluidas

| Receta | Nivel | Exp | Ingredientes | Requiere Chef |
|--------|-------|-----|--------------|---------------|
| Pasta | 1 | 15 | pasta, tomato_sauce | No |
| Ensalada | 2 | 18 | lettuce, tomato, cucumber, olive_oil | No |
| Sopa | 3 | 20 | vegetables, water, salt, herbs | No |
| Hamburguesa | 5 | 25 | bread, meat, lettuce, tomato | No |
| Pizza | 10 | 40 | dough, tomato_sauce, cheese, pepperoni | Sí — Chef rango 1 |
| Filete | 15 | 50 | meat, salt, pepper, butter | Sí — Chef rango 2 |
| Pastel | 20 | 75 | flour, sugar, eggs, butter, vanilla | Sí — Chef rango 3 |

---

## 💰 Licencias

### Estándar — $15 USD
- 1 servidor
- Soporte básico
- Actualizaciones menores por 3 meses

### Premium — $30 USD
- Hasta 3 servidores
- Soporte prioritario
- Actualizaciones por 1 año + acceso anticipado a nuevas features

### Empresarial — $60 USD
- Servidores ilimitados
- Soporte 24/7
- Actualizaciones de por vida + personalización incluida

---

## 📞 Contacto

**Desarrollador:** Emilio Ranucoli  
**Email:** emilio@ranuk.dev  
**Web:** [ranuk.dev](https://ranuk.dev)  
**Discord:** Emilio#1234

---

*Gracias por comprar FiveM-Coccion. Cualquier duda, escribime.* 🍽️