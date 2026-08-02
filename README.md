# 🍳 FiveM-Coccion - Sistema de Cocina Profesional

FiveM resource premium para sistema de cocina avanzado con soporte multi-framework (ESX y QB-Core), diseñado para servidores RolePlay que buscan inmersión y realismo en sus experiencias culinarias.

## ✨ Características Principales

### 🎮 Soporte Multi-Framework
- **ESX Framework** - Compatibilidad total con ExtendedRP y sus derivados
- **QB-Core Framework** - Integración perfecta with QBCore y sus modificaciones
- Auto-detección del framework activo en el servidor
- Sin necesidad de modificar el código base para cada framework

### 🍳 Sistema de Cocina Avanzado
- **Sistema de niveles y experiencia** - Los jugadores mejoran sus habilidades culinarias
- **7 recetas únicas** - Desde platos básicos hasta comidas gourmet
- **Sistema de progreso** - Los jugadores suben de nivel al cocinar
- **Multiplicador de habilidades** - A mayor nivel, más experiencia se obtiene
- **Requisitos de trabajo** - Algunas recetas requieren ser chef con cierto rango

### 🎨 Efectos Visuales Premium
- **Blips interactivos** en 3 ubicaciones de cocina
- **Marcadores 3D** animados (cian, rotación, movimiento vertical)
- **Sistema de partículas** - Humo y fuego durante la cocción
- **Animaciones realistas** de preparación de alimentos
- **Efectos de finalización** cuando la comida está lista

### 🛡️ Sistema Anti-Cheat
- **Control de distancia** - Los jugadores deben estar cerca de las cocinas
- **Enfriamiento entre cocciones** - Previene spam y trampas
- **Verificación de ingredientes** - Validación en el servidor
- **Registro de intentos de trampa** - Logs para administradores

### 🔧 Configuración Extensa
- Editor de recetas intuitivo
- Sistema de notificaciones personalizables
- Webhook de Discord para logs detallados
- Sistema de progresión ajustable
- Traducciones completas (ES/EN)

### 🌐 Multi-idioma
- **Español (ES)** - Traducción completa
- **English (EN)** - Full English support
- Sistema de fallback automático

## 📋 Requisitos del Servidor

### Frameworks Soportados
- **ESX Framework** (versión 1.2 o superior)
- **QB-Core Framework** (versión 3.0 o superior)

### Dependencias Opcionales
- **ox_lib** - Para barra de progreso mejorada (recomendado)
- **ESX/Inventory** - Para integración con inventario
- **Discord Webhooks** - Para logging automático

### Recursos Base Requeridos
- `es_extended` o `qb-core` según el framework
- Sistema de inventario compatible
- Sistema de jobs (para recetas de chef)

## 🚀 Instalación

### Método 1: Instalación Manual
1. Descarga el paquete comprado de Tebex
2. Descomprime el archivo en tu directorio de recursos
3. Renombra la carpeta a `coccion`
4. Copia la carpeta a `resources/` en tu servidor FiveM
5. Agrega `ensure coccion` a tu archivo `server.cfg`
6. Reinicia tu servidor

### Método 2: Instalación con Auto-Deploy
1. Desde el panel de administración de tu servidor FiveM
2. Navega a la sección de recursos
3. Usa la función "Upload Resource"
4. Selecciona el archivo `.zip` descargado
5. Habilita el recurso y reinicia el servidor

### Configuración Inicial
1. Edita `config.lua` según tus necesidades
2. Configura el webhook de Discord para logging
3. Ajusta las coordenadas de las cocinas a tu mapa
4. Personaliza las recetas según tu servidor

### Configuración de Base de Datos
Ejecuta el siguiente SQL en tu base de datos:

```sql
CREATE TABLE IF NOT EXISTS coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);
```

## 📸 Screenshots

*Nota: Las imágenes son solo para referencia, el recurso incluye los siguientes efectos visuales:*

1. **Menú de Cocina** - Interfaz intuitiva con todas las recetas disponibles
2. **Efectos de Cocina** - Partículas de humo y fuego durante la preparación
3. **Marcadores 3D** - Visuales en las ubicaciones de cocina del servidor
4. **Sistema de Niveles** - Indicador de progreso de habilidad culinaria
5. **Notificaciones** - Alertas elegantes para eventos importantes

## 🍽️ Recetas Disponibles

| Receta | Nivel Requerido | Experiencia | Ingredientes | Requiere Chef |
|--------|-----------------|-------------|--------------|---------------|
| Pasta | 1 | 15 | pasta, tomate_sauce | No |
| Ensalada | 2 | 18 | lettuce, tomato, cucumber, olive_oil | No |
| Sopa | 3 | 20 | vegetables, water, salt, herbs | No |
| Hamburguesa | 5 | 25 | bread, meat, lettuce, tomato | No |
| Pizza | 10 | 40 | dough, tomato_sauce, cheese, pepperoni | Sí (Chef - Rango 1) |
| Filete | 15 | 50 | meat, salt, pepper, butter | Sí (Chef - Rango 2) |
| Pastel | 20 | 75 | flour, sugar, eggs, butter, vanilla | Sí (Chef - Rango 3) |

## 🔄 Actualizaciones y Soporte

### Actualizaciones Incluidas
- Todas las actualizaciones menores y parches de seguridad
- Nuevas recetas gratuitas (1-2 por trimestre)
- Mejoras visuales y optimizaciones
- Corrección de bugs reportados

### Soporte Técnico
- **Chat de Discord** - Soporte prioritario para clientes
- **Base de conocimientos** - Documentación detallada
- **Actualizaciones automáticas** - Recibe las mejoras sin costo adicional
- **Compatibilidad garantizada** - Con futuras versiones de frameworks

### Política de Compatibilidad
- Garantía de compatibilidad con ESX/QB-Core por 6 meses
- Soporte para versiones menores gratuitas
- Anuncio anticipado de cambios importantes

## � Precios

### Licencia Estándar - $15 USD
- Uso en un solo servidor
- Soporte básico
- Actualizaciones menores por 3 meses
- Acceso a la documentación

### Licencia Premium - $30 USD
- Uso en hasta 3 servidores
- Soporte prioritario
- Actualizaciones por 1 año
- Acceso anticipado a nuevas características
- Personalización básica incluida

### Licenza Empresarial - $60 USD
- Uso en servidores ilimitados
- Soporte 24/7 prioritario
- Actualizaciones de por vida
- Personalización completa
- Implementación personalizada
- Consultoría gratuita

## 📞 Contacto

👨‍💻 **Desarrollador:** Emilio Ranucoli  
📧 **Email:** emilio@ranuk.dev  
🌐 **Web:** https://ranuk.dev  
💬 **Discord:** Emilio#1234  

### Formas de Pago
- PayPal
- Tarjetas de crédito/débito
- Criptomonedas (Bitcoin, Ethereum)

## 📝 Licencia

Este recurso está licenciado bajo MIT License. Al comprar el recurso, aceptas los términos de uso y condiciones de venta.

---

**Gracias por comprar FiveM-Coccion! Si tienes alguna pregunta, no dudes en contactarnos.** 🍽️✨

## Installation

1. Place the resource folder in your server's resources directory
2. Add `ensure coccion` to your server.cfg
3. Create the required database table:

```sql
CREATE TABLE IF NOT EXISTS coccion_player_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    level INT DEFAULT 1,
    experience INT DEFAULT 0,
    UNIQUE (identifier)
);
```

## Configuration

Edit `config.lua` to customize:

- Framework type (`esx` or `qbcore`)
- Debug mode
- Cooking settings
- Recipes

## Usage

- Press F2 (or bind a key) to open the cooking menu
- Select a recipe to cook
- Required ingredients will be consumed
- Cooked items will be added to your inventory

## API

### Client Exports

```lua
-- Get player cooking data
local playerData = exports['coccion']:GetPlayerData()

-- Get cooking config
local config = exports['coccion']:GetCookingConfig()
```

### Server Exports

```lua
-- Get player cooking data
local playerData = exports['coccion']:GetPlayerCookingData(identifier)

-- Add cooking experience
exports['coccion']:AddCookingExperience(identifier, amount)
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License.