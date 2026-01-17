ALTER VIEW View_Master_Finanzas AS
SELECT 
    -- 1. IDs
    F.FacturaID,
    F.CitaID, -- Útil si queremos hacer Drill-Through en Power BI
    D.DoctorID,

    -- 2. TIEMPOS (Servicio vs Cobro)
    C.FechaHora as FechaServicio,
    F.FechaPago,
    YEAR(F.FechaPago) as AnioCobro,
    MONTH(F.FechaPago) as MesCobro,
    dateName(MONTH,F.FechaPago) as NombreMes,


    -- 3. DIMENSIONES
    ISNULL(F.SeguroMedico, 'Particular') as SeguroMedico,
    ISNULL(F.EstadoPago, 'Desconocido') as EstadoPago,
    
    -- Consistencia: Usamos el mismo formato de nombre que en Operaciones
    CONCAT(D.Nombre, ' ', D.Apellido) as Doctor, 
    E.Nombre as Especialidad,

    -- 4. MÉTRICAS FINANCIERAS
    F.MontoTotal,
    
    -- KPI: Ciclo de Caja (Cash Conversion Cycle)
    -- Si es NULL (no pagado), el resultado será NULL, lo cual es correcto
    DATEDIFF(DAY, C.FechaHora, F.FechaPago) as DiasDeCobro
    

FROM Facturacion F
INNER JOIN Citas C ON F.CitaID = C.CitaID
INNER JOIN Doctores D ON C.DoctorID = D.DoctorID
INNER JOIN Especialidades E ON D.EspecialidadID = E.EspecialidadID;



