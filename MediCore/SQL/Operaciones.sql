CREATE VIEW View_Master_Operaciones AS
SELECT 
    -- 1. IDs (Vitales para contar y relacionar en Power BI)
    C.CitaID,
    D.DoctorID,
    P.PacienteID,

    -- 2. TIEMPO
    C.FechaHora, -- Mantenemos la fecha completa para Power BI
    YEAR(C.FechaHora) as Anio,
    DATENAME(MONTH, C.FechaHora) as NombreMes, -- Ej: 'January'
    
    -- 3. ACTORES
    CONCAT(D.Nombre, ' ', D.Apellido) as Doctor,
    E.Nombre as Especialidad, -- ¡Agregado! (Faltaba esto)
    CONCAT(P.Nombre, ' ', P.Apellido) as Paciente,
    
    -- 4. DEMOGRAFÍA LIMPIA
    ISNULL(P.Genero, 'No Especificado') as Genero,
    DATEDIFF(YEAR, P.FechaNacimiento, GETDATE()) as Edad,
    
    CASE
        WHEN DATEDIFF(YEAR, P.FechaNacimiento, GETDATE()) <= 18 THEN 'Pediatrico'
        WHEN DATEDIFF(YEAR, P.FechaNacimiento, GETDATE()) <= 60 THEN 'Adulto'
        ELSE 'Senior'
    END as GrupoEtario,

    -- 5. OPERACIÓN Y ESTADO
    ISNULL(C.Estado, 'Pendiente') as Estado,
    
    -- Turno (Lógica de Negocio)
    IIF(DATEPART(HOUR, C.FechaHora) < 12, 'Mañana', 'Tarde') AS Turno

FROM Citas C
INNER JOIN Pacientes P ON C.PacienteID = P.PacienteID
INNER JOIN Doctores D ON C.DoctorID = D.DoctorID
INNER JOIN Especialidades E ON D.EspecialidadID = E.EspecialidadID;