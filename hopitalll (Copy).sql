-- ============================================
-- BAZA E TE DHENAVE "SPITALI"
-- Detyre Kursi 2024-2025
-- ============================================




-- Kufizimet: PK, CHECK(Kati>0), UNIQUE(Emri), NOT NULL
-- ============================================
CREATE TABLE Departamenti (
    ID_Departamenti INT IDENTITY(1,1) PRIMARY KEY,
    Emri VARCHAR(50) NOT NULL UNIQUE,
    Kati INT NOT NULL CHECK (Kati > 0)
);

-- ============================================
-- 2. TABELA: Pacient
-- Kufizimet: PK, CHECK(Gjinia), CHECK(Grupi_Gjakut), UNIQUE(Telefon), NOT NULL
-- ============================================
CREATE TABLE Pacient (
    ID_Pacienti INT IDENTITY(1,1) PRIMARY KEY,
    Emri VARCHAR(50) NOT NULL,
    Mbiemri VARCHAR(50) NOT NULL,
    Data_Lindjes DATE NOT NULL,
    Gjinia CHAR(1) NOT NULL CHECK (Gjinia IN ('M','F')),
    Telefon VARCHAR(15) UNIQUE,
    Adresa VARCHAR(100) NOT NULL,
    Grupi_Gjakut VARCHAR(5) CHECK (Grupi_Gjakut IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);

-- ============================================
-- 3. TABELA: Mjeku
-- Kufizimet: PK, FK(ID_Departamenti), UNIQUE(Telefon), UNIQUE(Email), NOT NULL
-- ============================================
CREATE TABLE Mjeku (
    ID_Mjeku INT IDENTITY(1,1) PRIMARY KEY,
    Emri VARCHAR(50) NOT NULL,
    Mbiemri VARCHAR(50) NOT NULL,
    Specializimi VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    ID_Departamenti INT NOT NULL,
    CONSTRAINT FK_Mjeku_Departamenti FOREIGN KEY (ID_Departamenti)
        REFERENCES Departamenti(ID_Departamenti)
);

-- ============================================
-- 4. TABELA: Infermieri
-- Kufizimet: PK, FK(ID_Departamenti), CHECK(Turni), NOT NULL
-- ============================================
CREATE TABLE Infermieri (
    ID_Infermieri INT IDENTITY(1,1) PRIMARY KEY,
    Emri VARCHAR(50) NOT NULL,
    Mbiemri VARCHAR(50) NOT NULL,
    ID_Departamenti INT NOT NULL,
    Turni VARCHAR(20) CHECK (Turni IN ('Mengjes','Dreke','Nate')),
    CONSTRAINT FK_Infermieri_Departamenti FOREIGN KEY (ID_Departamenti)
        REFERENCES Departamenti(ID_Departamenti)
);

-- ============================================
-- 5. TABELA: Dhomat
-- Kufizimet: PK, FK(ID_Departamenti), CHECK(Lloji), CHECK(Statusi), DEFAULT(Statusi), NOT NULL
-- ============================================
CREATE TABLE Dhomat (
    Nr_Dhome INT PRIMARY KEY,
    Lloji VARCHAR(20) CHECK (Lloji IN ('Standard','VIP','ICU')),
    Statusi VARCHAR(10) DEFAULT 'E lire' CHECK (Statusi IN ('E lire','E zene')),
    ID_Departamenti INT NOT NULL,
    CONSTRAINT FK_Dhomat_Departamenti FOREIGN KEY (ID_Departamenti)
        REFERENCES Departamenti(ID_Departamenti)
);

-- ============================================
-- 6. TABELA: Sherbimi
-- Kufizimet: PK, CHECK(Kosto>=0), UNIQUE(Emri_Sherbimit), NOT NULL
-- ============================================
CREATE TABLE Sherbimi (
    ID_Sherbimi INT IDENTITY(1,1) PRIMARY KEY,
    Emri_Sherbimit VARCHAR(100) NOT NULL UNIQUE,
    Kosto DECIMAL(10,2) NOT NULL CHECK (Kosto >= 0)
);

-- ============================================
-- 7. TABELA: Ilac
-- Kufizimet: PK, CHECK(Sasia_ne_depo>=0), UNIQUE(Emri_Ilacit), UNIQUE(Barkodi), DEFAULT(Sasia_ne_depo)
-- ============================================
CREATE TABLE Ilac (
    ID_Ilaci INT IDENTITY(1,1) PRIMARY KEY,
    Emri_Ilacit VARCHAR(100) NOT NULL UNIQUE,
    Barkodi VARCHAR(50) UNIQUE,
    Sasia_ne_depo INT DEFAULT 0 CHECK (Sasia_ne_depo >= 0)
);

-- ============================================
-- 8. TABELA: Apuntament
-- Kufizimet: PK, FK(ID_Pacienti), FK(ID_Mjeku), CHECK(Konfirmimi), DEFAULT(Konfirmimi), NULL(Ankesat)
-- ============================================
CREATE TABLE Apuntament (
    ID_Vizite INT IDENTITY(1,1) PRIMARY KEY,
    ID_Pacienti INT NOT NULL,
    ID_Mjeku INT NOT NULL,
    Data DATETIME NOT NULL,
    Konfirmimi VARCHAR(10) DEFAULT 'Jo' CHECK (Konfirmimi IN ('Po','Jo')),
    Ankesat VARCHAR(255) NULL,
    CONSTRAINT FK_Apuntament_Pacient FOREIGN KEY (ID_Pacienti)
        REFERENCES Pacient(ID_Pacienti),
    CONSTRAINT FK_Apuntament_Mjeku FOREIGN KEY (ID_Mjeku)
        REFERENCES Mjeku(ID_Mjeku)
);

-- ============================================
-- 9. TABELA: Receta
-- Kufizimet: PK, FK(ID_Pacienti), FK(ID_Mjeku), FK(ID_Ilaci), DEFAULT(Data_Leshimit), NOT NULL
-- FIX: DEFAULT CAST(GETDATE() AS DATE) sepse Data_Leshimit eshte tip DATE, jo DATETIME
-- ============================================
CREATE TABLE Receta (
    ID_Receta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Pacienti INT NOT NULL,
    ID_Mjeku INT NOT NULL,
    ID_Ilaci INT NOT NULL,
    Doza VARCHAR(50) NOT NULL,
    Data_Leshimit DATE DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Receta_Pacient FOREIGN KEY (ID_Pacienti)
        REFERENCES Pacient(ID_Pacienti),
    CONSTRAINT FK_Receta_Mjeku FOREIGN KEY (ID_Mjeku)
        REFERENCES Mjeku(ID_Mjeku),
    CONSTRAINT FK_Receta_Ilac FOREIGN KEY (ID_Ilaci)
        REFERENCES Ilac(ID_Ilaci)
);

-- ============================================
-- 10. TABELA: Historiku_mjekesor
-- Kufizimet: PK, FK(ID_Pacienti), DEFAULT(Data_regjistrimit), NOT NULL
-- ============================================
CREATE TABLE Historiku_mjekesor (
    ID_Historiku INT IDENTITY(1,1) PRIMARY KEY,
    Diagnoza VARCHAR(255) NOT NULL,
    Simptomat VARCHAR(255) NOT NULL,
    Data_regjistrimit DATETIME DEFAULT GETDATE(),
    ID_Pacienti INT NOT NULL,
    CONSTRAINT FK_Historiku_Pacient FOREIGN KEY (ID_Pacienti)
        REFERENCES Pacient(ID_Pacienti)
);

-- ============================================
-- 11. TABELA: Faturat
-- Kufizimet: PK, FK(ID_Pacienti), CHECK(Shuma>=0), CHECK(Statusi_Pageses), DEFAULT(Statusi_Pageses), NOT NULL
-- ============================================
CREATE TABLE Faturat (
    ID_Fatura INT IDENTITY(1,1) PRIMARY KEY,
    Shuma DECIMAL(10,2) NOT NULL CHECK (Shuma >= 0),
    Data_Pageses DATE NOT NULL,
    Statusi_Pageses VARCHAR(20) DEFAULT 'Pende' CHECK (Statusi_Pageses IN ('Cash','Karte Krediti','Pende')),
    ID_Pacienti INT NOT NULL,
    CONSTRAINT FK_Faturat_Pacient FOREIGN KEY (ID_Pacienti)
        REFERENCES Pacient(ID_Pacienti)
);

-- ============================================
-- INSERT: Departamenti (5 rekorde)
-- ============================================
INSERT INTO Departamenti (Emri, Kati) VALUES
('Kardiologji', 2),
('Neurologji', 3),
('Psikiatri', 4),
('Pediatri', 1),
('Ortopedi', 2);

-- ============================================
-- INSERT: Pacient (5 rekorde)
-- ============================================
INSERT INTO Pacient (Emri, Mbiemri, Data_Lindjes, Gjinia, Telefon, Adresa, Grupi_Gjakut) VALUES
('Arben', 'Hoxha', '1985-03-15', 'M', '0691234567', 'Rruga e Durresit, Tirane', 'A+'),
('Mira', 'Kola', '1990-07-22', 'F', '0682345678', 'Bulevardi Zogu I, Tirane', 'O-'),
('Besnik', 'Prifti', '1978-11-05', 'M', '0673456789', 'Rruga e Kavajes, Tirane', 'B+'),
('Elena', 'Leka', '1995-01-30', 'F', '0664567890', 'Rruga e Elbasanit, Tirane', 'AB+'),
('Dritan', 'Basha', '1982-09-12', 'M', '0655678901', 'Rruga e Dibres, Tirane', 'A-');

-- ============================================
-- INSERT: Mjeku (5 rekorde)
-- FIX: Emri dhe Mbiemri ndare saktesisht - prefisi 'Dr.' i kaluar te Emri
-- ============================================
INSERT INTO Mjeku (Emri, Mbiemri, Specializimi, Telefon, Email, ID_Departamenti) VALUES
('Fatmir', 'Mehmeti', 'Kardiolog', '0691111111', 'fatmir.mehmeti@spitali.com', 1),
('Anila', 'Koci', 'Neurologe', '0682222222', 'anila.koci@spitali.com', 2),
('Bledar', 'Hysa', 'Psikiater', '0673333333', 'bledar.hysa@spitali.com', 3),
('Sonila', 'Duka', 'Pediatre', '0664444444', 'sonila.duka@spitali.com', 4),
('Genci', 'Prifti', 'Ortoped', '0655555555', 'genci.prifti@spitali.com', 5);

-- ============================================
-- INSERT: Infermieri (5 rekorde)
-- ============================================
INSERT INTO Infermieri (Emri, Mbiemri, ID_Departamenti, Turni) VALUES
('Agnesa', 'Berisha', 1, 'Mengjes'),
('Blerim', 'Kuka', 2, 'Dreke'),
('Dorina', 'Shala', 3, 'Nate'),
('Ermal', 'Gjoka', 4, 'Mengjes'),
('Flora', 'Hoxha', 5, 'Dreke');

-- ============================================
-- INSERT: Dhomat (5 rekorde)
-- ============================================
INSERT INTO Dhomat (Nr_Dhome, Lloji, Statusi, ID_Departamenti) VALUES
(101, 'Standard', 'E lire', 1),
(102, 'VIP', 'E zene', 1),
(201, 'Standard', 'E lire', 2),
(202, 'ICU', 'E zene', 2),
(301, 'Standard', 'E lire', 3);

-- ============================================
-- INSERT: Sherbimi (5 rekorde)
-- ============================================
INSERT INTO Sherbimi (Emri_Sherbimit, Kosto) VALUES
('Konsulte e pergjithshme', 50.00),
('Ekzaminim kardiologjik', 150.00),
('MRI (Rezonance magnetike)', 300.00),
('Terapi fizike', 80.00),
('Vaksinim', 30.00);

-- ============================================
-- INSERT: Ilac (5 rekorde)
-- ============================================
INSERT INTO Ilac (Emri_Ilacit, Barkodi, Sasia_ne_depo) VALUES
('Paracetamol', 'BAR001', 500),
('Ibuprofen', 'BAR002', 300),
('Amoxicilin', 'BAR003', 200),
('Omeprazol', 'BAR004', 150),
('Metformin', 'BAR005', 100);

-- ============================================
-- INSERT: Apuntament (5 rekorde)
-- ============================================
INSERT INTO Apuntament (ID_Pacienti, ID_Mjeku, Data, Konfirmimi, Ankesat) VALUES
(1, 1, '2025-01-15 09:00:00', 'Po', 'Dhimbje gjoksi'),
(2, 2, '2025-01-16 10:30:00', 'Po', 'Migrene kronike'),
(3, 3, '2025-01-17 14:00:00', 'Jo', 'Ankth'),
(4, 4, '2025-01-18 11:00:00', 'Po', 'Temperatur e larte'),
(5, 5, '2025-01-19 16:00:00', 'Jo', 'Dhimbje kyci');

-- ============================================
-- INSERT: Receta (5 rekorde)
-- ============================================
INSERT INTO Receta (ID_Pacienti, ID_Mjeku, ID_Ilaci, Doza, Data_Leshimit) VALUES
(1, 1, 1, '1 tablete 3 here ne dite', '2025-01-15'),
(2, 2, 2, '1 tablete pas vaktit', '2025-01-16'),
(4, 4, 3, '1 kapsule 2 here ne dite', '2025-01-18'),
(1, 1, 4, '1 tablete ne mengjes', '2025-01-20'),
(3, 3, 5, '1 tablete pas darke', '2025-01-21');

-- ============================================
-- INSERT: Historiku_mjekesor (5 rekorde)
-- ============================================
INSERT INTO Historiku_mjekesor (Diagnoza, Simptomat, Data_regjistrimit, ID_Pacienti) VALUES
('Hipertension arterial', 'Dhimbje koke, vertigo', '2024-12-01 10:00:00', 1),
('Migrene', 'Dhimbje koke e forte, te vertitura', '2024-11-15 14:30:00', 2),
('Depresion', 'Lodhje, humbje interesi', '2024-10-20 09:00:00', 3),
('Bronkit akut', 'Koll e forte, temperature', '2024-12-10 11:00:00', 4),
('Artroz', 'Dhimbje gjunji', '2024-09-05 16:00:00', 5);

-- ============================================
-- INSERT: Faturat (5 rekorde)
-- ============================================
INSERT INTO Faturat (Shuma, Data_Pageses, Statusi_Pageses, ID_Pacienti) VALUES
(200.00, '2025-01-15', 'Cash', 1),
(450.00, '2025-01-16', 'Karte Krediti', 2),
(150.00, '2025-01-17', 'Pende', 3),
(80.00, '2025-01-18', 'Cash', 4),
(300.00, '2025-01-19', 'Karte Krediti', 5);

-- ============================================
-- 5 QUERY MBI BAZEN E TE DHENAVE
-- ============================================

-- QUERY 1: Lista e pacienteve me takime te konfirmuara
SELECT
    p.Emri + ' ' + p.Mbiemri AS Pacienti,
    m.Emri + ' ' + m.Mbiemri AS Mjeku,
    a.Data,
    a.Ankesat
FROM Apuntament a
JOIN Pacient p ON a.ID_Pacienti = p.ID_Pacienti
JOIN Mjeku m ON a.ID_Mjeku = m.ID_Mjeku
WHERE a.Konfirmimi = 'Po'
ORDER BY a.Data;

-- QUERY 2: Totali i faturave sipas statusit te pageses
SELECT
    Statusi_Pageses,
    COUNT(*) AS Numri_Faturave,
    SUM(Shuma) AS Totali
FROM Faturat
GROUP BY Statusi_Pageses;

-- QUERY 3: Mjeket dhe numri i pacienteve qe kane trajtuar
SELECT
    m.Emri + ' ' + m.Mbiemri AS Mjeku,
    m.Specializimi,
    COUNT(DISTINCT a.ID_Pacienti) AS Numri_Pacienteve
FROM Mjeku m
LEFT JOIN Apuntament a ON m.ID_Mjeku = a.ID_Mjeku
GROUP BY m.ID_Mjeku, m.Emri, m.Mbiemri, m.Specializimi
ORDER BY Numri_Pacienteve DESC;

-- QUERY 4: Ilacet me sasi ne depo me pak se 200
SELECT
    Emri_Ilacit,
    Barkodi,
    Sasia_ne_depo
FROM Ilac
WHERE Sasia_ne_depo < 200
ORDER BY Sasia_ne_depo;

-- QUERY 5: Historiku mjekesor i nje pacienti specifik me te dhena te plota
SELECT
    p.Emri + ' ' + p.Mbiemri AS Pacienti,
    p.Data_Lindjes,
    p.Grupi_Gjakut,
    hm.Diagnoza,
    hm.Simptomat,
    hm.Data_regjistrimit
FROM Historiku_mjekesor hm
JOIN Pacient p ON hm.ID_Pacienti = p.ID_Pacienti
WHERE p.ID_Pacienti = 1
ORDER BY hm.Data_regjistrimit DESC;

-- ============================================
-- FUND I SKRIPTIT
-- ============================================

