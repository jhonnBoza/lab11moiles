# Laboratorio S11 — Monorepo (una sola app)

## Proyecto único

Abre solo: **`lab11jhnn/lab11jhnn.xcodeproj`** → **⌘R**

Al iniciar verás el **dashboard** con 3 actividades. Cada una abre su módulo por separado.

**Datos de ejemplo:** la primera vez que abres la app se cargan contactos, alumnos y productos como en el laboratorio (solo si la base está vacía).

Si ya ejecutaste la app antes y no ves datos: en el simulador borra la app (**long press → Delete App**) y vuelve a correr **⌘R**.

| Actividad | Pantalla | Tecnología |
|-----------|----------|------------|
| **01** Contactos | Lista + alerta Agregar Contacto | UIKit + Core Data |
| **02** Alumnos | Lista, detalle, Nuevo Alumno | SwiftUI + SwiftData |
| **03** Productos | CRUD + imagen opcional | SwiftUI + SwiftData |

## Estructura del código (monorepo)

```
lab11jhnn/
├── DashboardViewController.swift    ← menú inicial
├── ContactosViewController.swift    ← Actividad 01
├── Actividad02/                     ← Alumnos (SwiftData)
├── Actividad03/                     ← Productos (SwiftData)
└── lab11jhnn.xcdatamodeld           ← solo entidad Contacto
```

## Proyectos antiguos (opcionales)

`Semana11SwiftUI/` y `ProductosLab/` quedaron como referencia; **ya no hace falta abrirlos** — todo está integrado en `lab11jhnn`.

## Capturas para el informe

1. Dashboard con las 3 actividades  
2. Actividad 01: lista, alerta, delete  
3. Actividad 02: alumnos + detalle  
4. Actividad 03: productos + formulario  
