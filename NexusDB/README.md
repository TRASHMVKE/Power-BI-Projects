# 📦 Nexus Supply & Logistics: End-to-End Analytics

![Vista General] ![alt text](<Dashboard 30_12_2025 10_48_08 a.m.-1.png>)

## 🔗 [👉 CLIC AQUÍ PARA VER EL DASHBOARD INTERACTIVO](https://app.powerbi.com/view?r=eyJrIjoiMTdlOTE1OTQtNzEyZi00OGM1LTg4MWQtYzJkYjY4M2YzOTJmIiwidCI6ImIzODQ5ZGI2LWExMTctNDJmZi04OTI5LThmY2Y0ODdiM2MxOCIsImMiOjJ9)

---

## 📌 Descripción del Proyecto
Este proyecto simula un entorno empresarial real para "Nexus Supply", analizando el ciclo completo desde la venta hasta la entrega y las devoluciones.
A diferencia de los proyectos básicos, aquí no se usó un Excel limpio. Se partió de una **Base de Datos Transaccional (OLTP)** compleja y normalizada, requiriendo ingeniería de datos previa.

## ⚙️ Arquitectura Técnica (El Desafío)
El flujo de datos fue diseñado para optimizar el rendimiento y la integridad:

### 1. SQL Server (Backend & ETL)
* **Generación de Datos:** Script procedural (T-SQL) para simular **2,000 transacciones** históricas con lógica de negocio (ej: envíos tardíos aleatorios, devoluciones condicionadas).
* **Vistas ETL (Extract-Transform-Load):** Se crearon Vistas SQL (`vw_FactVentas`, `vw_FactDevoluciones`) para:
    * Desnormalizar el modelo copo de nieve original.
    * Calcular métricas a nivel de fila (Venta Neta, Lead Time) en el servidor antes de llegar a Power BI.

### 2. Power BI (Frontend & Modeling)
* **Modelo de Galaxia (Galaxy Schema):** El reto principal fue unificar dos tablas de hechos con granularidad distinta (**Ventas** y **Devoluciones**).
* **Solución:** Se implementó una arquitectura multi-fact compartiendo dimensiones conformadas (Cliente, Producto) y una **Tabla Calendario Maestra** gobernando ambas líneas temporales.
* **DAX Avanzado:** Cálculo de KPIs cruzados como la *Tasa de Devolución* (% Return Rate) y *Análisis de Pareto*.

---
*Autor: Michael Smill Rodriguez 