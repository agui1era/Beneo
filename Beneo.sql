USE [Beneo]
GO
/****** Object:  UserDefinedFunction [dbo].[ConcatenarHerramientasProgramados]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ConcatenarHerramientasProgramados]
(
	@IdPrograActReg int
)
RETURNS varchar(Max)
AS
BEGIN

	Declare @Concatena varchar(MAx) = ''

	SELECT       distinct @Concatena = @Concatena +  Herramientas.Nombre + ', '
	FROM            ProgramacionActividadHerr INNER JOIN
							 Herramientas ON ProgramacionActividadHerr.IdHerramienta = Herramientas.Id
	WHERE        (ProgramacionActividadHerr.IdProgramacionActividadRegistro = @IdPrograActReg)

	return @Concatena


END
GO
/****** Object:  UserDefinedFunction [dbo].[ConcatenarProductosProgramados]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ConcatenarProductosProgramados]
(
	@IdPrograActReg int
)
RETURNS varchar(Max)
AS
BEGIN

	Declare @Concatena varchar(MAx) = ''

	SELECT      distinct @Concatena = @Concatena +  Producto.Descripcion + ', '
	FROM            ProgramacionActividadProd INNER JOIN
							 Producto ON ProgramacionActividadProd.IdProducto = Producto.Id
	WHERE        (ProgramacionActividadProd.IdProgramacionActividadRegistro = @IdPrograActReg)

	return @Concatena


END
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[Split](@data NVARCHAR(MAX), @delimiter NVARCHAR(5))
RETURNS @t TABLE (data NVARCHAR(max))
AS
BEGIN
    
    DECLARE @textXML XML;
    SELECT    @textXML = CAST('<d>' + REPLACE(@data, @delimiter, '</d><d>') + '</d>' AS XML);

    INSERT INTO @t(data)
    SELECT  T.split.value('.', 'nvarchar(max)') AS data
    FROM    @textXML.nodes('/d') T(split)
    
    RETURN
END

GO
/****** Object:  Table [dbo].[AccOpcion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccOpcion](
	[IdOpcion] [int] NOT NULL,
	[Opcion] [varchar](50) NOT NULL,
	[Accion] [tinyint] NOT NULL,
	[Constante] [varchar](40) NULL,
	[Observaciones] [varchar](2000) NULL,
	[IdGrupo] [int] NULL,
 CONSTRAINT [PK_AccOpcion] PRIMARY KEY CLUSTERED 
(
	[IdOpcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccOpcionGrupo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccOpcionGrupo](
	[IdGrupo] [int] IDENTITY(1,1) NOT NULL,
	[Grupo] [varchar](50) NOT NULL,
	[Orden] [int] NOT NULL,
 CONSTRAINT [PK_AccOpcionGrupo] PRIMARY KEY CLUSTERED 
(
	[IdGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccPerfil]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccPerfil](
	[IdPerfil] [int] NOT NULL,
	[Perfil] [varchar](30) NOT NULL,
	[IdUsuarioMod] [int] NOT NULL,
	[FecMod] [datetime] NOT NULL,
 CONSTRAINT [PK_AccPerfil] PRIMARY KEY CLUSTERED 
(
	[IdPerfil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccPerfilOpcion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccPerfilOpcion](
	[IdPerfil] [int] NOT NULL,
	[IdOpcion] [int] NOT NULL,
	[Ver] [bit] NOT NULL,
	[Editar] [bit] NOT NULL,
 CONSTRAINT [PK_AccPerfilOpcion] PRIMARY KEY CLUSTERED 
(
	[IdPerfil] ASC,
	[IdOpcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccUsuario]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccUsuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[nombre_empleado] [varchar](80) NOT NULL,
	[usu_usuario] [nvarchar](20) NOT NULL,
	[Foto_usuario] [varchar](max) NULL,
	[Clave] [bigint] NULL,
	[Administrador] [bit] NOT NULL,
	[IdUsuarioTipo] [int] NOT NULL,
	[Email] [varchar](150) NULL,
	[Celular] [varchar](30) NULL,
	[Observacion] [varchar](4000) NULL,
	[Activo] [bit] NOT NULL,
	[CambiarClave] [bit] NOT NULL,
	[Identificador] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AccUsuario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccUsuarioOpcion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccUsuarioOpcion](
	[IdUsuario] [int] NOT NULL,
	[IdOpcion] [int] NOT NULL,
	[Ver] [bit] NOT NULL,
	[Editar] [bit] NOT NULL,
 CONSTRAINT [PK_AccUsuarioOpcion] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdOpcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccUsuarioTipo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccUsuarioTipo](
	[Id] [int] NOT NULL,
	[Tipo] [varchar](30) NOT NULL,
 CONSTRAINT [PK_AccUsuarioTipo_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Actividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Actividad](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Actividad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActividadCategoria]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActividadCategoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdActividad] [int] NOT NULL,
	[IdCategoria] [int] NOT NULL,
 CONSTRAINT [PK_ActividadCategoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActividadHerramienta]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActividadHerramienta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCategoriaH] [int] NOT NULL,
	[IdActividad] [int] NOT NULL,
 CONSTRAINT [PK_ActividadHerramienta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActividadProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActividadProducto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdActividad] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
 CONSTRAINT [PK_ActividadProducto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AsignacionActividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AsignacionActividad](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
	[IdTemporada] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IdLugar] [int] NOT NULL,
	[IdEnsayo] [int] NOT NULL,
	[IdUsuario] [int] NULL,
 CONSTRAINT [PK_AsignacionActividad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bodega]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bodega](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLugar] [int] NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Bodega] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoriaProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoriaProducto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](150) NOT NULL,
	[Categoria] [varchar](150) NOT NULL,
 CONSTRAINT [PK_CategoriaProducto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Configuracion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configuracion](
	[Id] [int] NOT NULL,
	[ServidorSMTP] [varchar](150) NULL,
	[PuertoSMTP] [int] NULL,
	[SSL] [bit] NOT NULL,
	[UsuarioSMTP] [varchar](150) NULL,
	[Clave] [varchar](50) NULL,
	[URLSistema] [varchar](1500) NULL,
 CONSTRAINT [PK_Configuracion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiaSemana]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiaSemana](
	[Id] [int] NOT NULL,
	[Dia] [varchar](30) NOT NULL,
 CONSTRAINT [PK_DiaSemana] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ensayo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ensayo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTemporada] [int] NOT NULL,
	[IdLugar] [int] NULL,
	[IdEspecie] [int] NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[IdResponsable] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
	[CantTratamiento] [int] NOT NULL,
	[CantRepeticion] [int] NOT NULL,
	[CantCosechas] [int] NOT NULL,
	[IdEnsayoRel] [int] NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
	[NumeroVersion] [int] NOT NULL,
 CONSTRAINT [PK_Ensayo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnsayoDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnsayoDoc](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdEnsayo] [int] NOT NULL,
	[Nombre] [varchar](150) NOT NULL,
	[NombreArchivo] [varchar](150) NOT NULL,
	[Archivo] [image] NOT NULL,
	[Obligatorio] [bit] NULL,
 CONSTRAINT [PK_EnsayoDoc] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnsayoFechaSiembra]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnsayoFechaSiembra](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdEnsayo] [int] NOT NULL,
	[FechaSiembra] [date] NOT NULL,
	[Tratamientos] [varchar](150) NULL,
 CONSTRAINT [PK_EnsayoFechaSiembra] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnsayoFechaSiembraTemp]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnsayoFechaSiembraTemp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdEnsayo] [int] NOT NULL,
	[FechaSiembra] [date] NOT NULL,
	[Tratamientos] [varchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Especie]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Especie](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Especie] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Existencia]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Existencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProducto] [int] NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[IdBodega] [int] NOT NULL,
	[FechaVcto] [date] NULL,
	[IdHerramienta] [int] NULL,
 CONSTRAINT [PK_Existencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hallazgo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hallazgo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [int] NOT NULL,
	[Asunto] [varchar](250) NOT NULL,
	[Descripcion] [varchar](500) NOT NULL,
	[Fecha] [date] NOT NULL,
	[IdEnsayo] [int] NULL,
	[IdEstado] [int] NOT NULL,
	[IdHallazgoAsunto] [int] NOT NULL,
	[IdTipoHallazgo] [int] NOT NULL,
	[IdUsuarioCrea] [int] NOT NULL,
	[FechaCrea] [date] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [date] NULL,
 CONSTRAINT [PK_Hallazgo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallazgoAsunto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallazgoAsunto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Asunto] [varchar](250) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_HallazgoAsunto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallazgoComentario]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallazgoComentario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Comentario] [varchar](1000) NOT NULL,
	[IdHallazgo] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_HallazgoComentario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallazgoEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallazgoEstado](
	[Id] [int] NOT NULL,
	[Estado] [varchar](50) NOT NULL,
 CONSTRAINT [PK_HallazgoEstado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallazgoImagen]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallazgoImagen](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdHallazgo] [int] NOT NULL,
	[Imagen] [image] NOT NULL,
	[Extension] [varchar](50) NOT NULL,
 CONSTRAINT [PK_HallazgoImagen] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallazgoTipo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallazgoTipo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TipoHallazgo] [varchar](150) NOT NULL,
 CONSTRAINT [PK_HallazgoTipo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HerramientaCategoria]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HerramientaCategoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](50) NOT NULL,
	[Categoria] [varchar](150) NOT NULL,
 CONSTRAINT [PK_HerramientaCategoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Herramientas]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Herramientas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](150) NOT NULL,
	[Nombre] [varchar](150) NOT NULL,
	[IdCategoria] [int] NULL,
 CONSTRAINT [PK_Herramientas_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Herramie__06370DAC84096616] UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Herramie__75E3EFCF94F98255] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lugar]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lugar](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTemporada] [int] NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Lugar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Merma]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Merma](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Observacion] [varchar](max) NOT NULL,
	[IdMotivo] [int] NOT NULL,
	[IdProducto] [int] NULL,
	[IdHerramienta] [int] NULL,
	[IdUsuarioCrea] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
	[IdBodega] [int] NULL,
 CONSTRAINT [PK_Merma] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MermaMotivo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MermaMotivo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Motivo] [varchar](150) NOT NULL,
 CONSTRAINT [PK_MermaMotivo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movimiento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProducto] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Movimiento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Descripcion] [varchar](250) NOT NULL,
	[IdUnidadMedida] [int] NOT NULL,
	[IdUsuarioCrea] [int] NOT NULL,
	[FechaCrea] [date] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [date] NULL,
	[IdCategoria] [int] NULL,
	[Limite] [decimal](18, 2) NULL,
	[IngredienteActivo] [varchar](150) NULL,
 CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Programacion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Programacion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTemporada] [int] NOT NULL,
	[IdEnsayo] [int] NULL,
	[IdLugar] [int] NOT NULL,
	[IdResponsable] [int] NULL,
	[IdEstado] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Programacion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividad](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacion] [int] NOT NULL,
	[Actividad] [varchar](250) NOT NULL,
	[FechaDesde] [date] NOT NULL,
	[FechaHasta] [date] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdPrioridad] [int] NOT NULL,
	[Dias] [varchar](100) NULL,
	[FechaCrea] [datetime] NOT NULL,
	[Tratamiento] [varchar](500) NULL,
	[IdPrograActReprogra] [int] NULL,
	[Observacion] [varchar](1500) NULL,
	[dds] [int] NULL,
	[ValorDosis] [decimal](18, 2) NULL,
	[IdMedida] [int] NULL,
	[IdMedidaValor] [int] NULL,
	[TextoDosis] [varchar](50) NULL,
	[IdSuperficieObj] [int] NULL,
	[ValorTotalDosis] [decimal](18, 2) NULL,
	[ValorSuperficieObj] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ProgramacionActividad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadDoc](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
	[Archivo] [varchar](150) NOT NULL,
	[Descripcion] [varchar](1500) NULL,
	[Documento] [image] NOT NULL,
	[Obligatorio] [bit] NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadDoc] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadEstado](
	[Id] [int] NOT NULL,
	[Estado] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadEstado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadEx]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadEx](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividadRegistro] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[Grupo] [int] NULL,
 CONSTRAINT [PK_ProgramacionActividadEx] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadHerr]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadHerr](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividadRegistro] [int] NOT NULL,
	[IdHerramienta] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[Grupo] [int] NULL,
	[Merma] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadHerr] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadMotivo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadMotivo](
	[Id] [int] NOT NULL,
	[Motivo] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadMotivo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadProd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadProd](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividadRegistro] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[Grupo] [int] NULL,
	[Merma] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadProd] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadProducto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadProducto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadRegEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadRegEstado](
	[Id] [int] NOT NULL,
	[Estado] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadRegEstado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadRegistro]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadRegistro](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[FechaRealizado] [date] NULL,
	[IdEstado] [int] NOT NULL,
	[IdMotivo] [int] NULL,
	[ObsMotivo] [varchar](1500) NULL,
	[Responsables] [varchar](500) NULL,
	[Auxiliares] [varchar](500) NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
 CONSTRAINT [PK_ProgramacionActividadRegistro] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionActividadRegistroDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionActividadRegistroDoc](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
	[IdProgramacionActividadRegistro] [int] NULL,
	[IdProgramacionActividadDoc] [int] NULL,
	[Archivo] [varchar](150) NOT NULL,
	[Descripcion] [varchar](1500) NULL,
	[Documento] [image] NOT NULL,
	[IdEnsayoDoc] [int] NULL,
 CONSTRAINT [PK_ProgramacionActividadRegistroDoc] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionDia]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionDia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDia] [int] NOT NULL,
	[IdProgramacionActividad] [int] NOT NULL,
 CONSTRAINT [PK_ProgramacionDia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionDoc](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProgramacion] [int] NOT NULL,
	[Nombre] [varchar](150) NOT NULL,
	[NombreArchivo] [varchar](150) NOT NULL,
	[Archivo] [image] NOT NULL,
 CONSTRAINT [PK_ProgramacionDoc] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionEstado](
	[Id] [int] NOT NULL,
	[Estado] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ProgramacionEstado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramacionPrioridad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramacionPrioridad](
	[Id] [int] NOT NULL,
	[Prioridad] [varchar](30) NOT NULL,
	[Color] [varchar](20) NOT NULL,
 CONSTRAINT [PK_ProgramacionPrioridad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recepcion]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recepcion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [int] NULL,
	[Fecha] [date] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdBodega] [int] NULL,
	[Observacion] [varchar](1500) NULL,
	[IdUsuarioCrea] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Recepcion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecepcionDet]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecepcionDet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRecepcion] [int] NOT NULL,
	[IdProducto] [int] NULL,
	[Cantidad] [decimal](18, 2) NOT NULL,
	[FechaVcto] [date] NULL,
	[IdHerramienta] [int] NULL,
 CONSTRAINT [PK_RecepcionDet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecepcionEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecepcionEstado](
	[Id] [int] NOT NULL,
	[Estado] [varchar](30) NOT NULL,
 CONSTRAINT [PK_RecepcionEstado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Temporada]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temporada](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[FechaDesde] [date] NOT NULL,
	[FechaHasta] [date] NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Temporada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tratamiento]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tratamiento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](30) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCrea] [datetime] NOT NULL,
	[IdUsuarioMod] [int] NULL,
	[FechaMod] [datetime] NULL,
 CONSTRAINT [PK_Tratamiento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadMedida]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadMedida](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Sigla] [varchar](50) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Factor] [decimal](18, 2) NULL,
	[Base] [bit] NOT NULL,
	[IdUMBase] [int] NULL,
 CONSTRAINT [PK_UnidadMedida] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccPerfil] ADD  CONSTRAINT [DF_AccPerfil_FecMod]  DEFAULT (getdate()) FOR [FecMod]
GO
ALTER TABLE [dbo].[AccPerfilOpcion] ADD  CONSTRAINT [DF_AccPerfilOpcion_Ver]  DEFAULT ((0)) FOR [Ver]
GO
ALTER TABLE [dbo].[AccPerfilOpcion] ADD  CONSTRAINT [DF_AccPerfilOpcion_Editar]  DEFAULT ((0)) FOR [Editar]
GO
ALTER TABLE [dbo].[AccUsuario] ADD  CONSTRAINT [DF_AccUsuario_Administrador]  DEFAULT ((0)) FOR [Administrador]
GO
ALTER TABLE [dbo].[AccUsuario] ADD  CONSTRAINT [DF_AccUsuario_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[AccUsuario] ADD  CONSTRAINT [DF_AccUsuario_CambiarClave]  DEFAULT ((1)) FOR [CambiarClave]
GO
ALTER TABLE [dbo].[AccUsuario] ADD  CONSTRAINT [DF_AccUsuario_Identificador]  DEFAULT (newid()) FOR [Identificador]
GO
ALTER TABLE [dbo].[Configuracion] ADD  CONSTRAINT [DF_Configuracion_SSL]  DEFAULT ((0)) FOR [SSL]
GO
ALTER TABLE [dbo].[Ensayo] ADD  CONSTRAINT [DF_Ensayo_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Ensayo] ADD  CONSTRAINT [DF_Ensayo_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[Movimiento] ADD  CONSTRAINT [DF_Movimiento_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[Producto] ADD  CONSTRAINT [DF_Producto_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[Programacion] ADD  CONSTRAINT [DF_Programacion_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[ProgramacionActividad] ADD  CONSTRAINT [DF_ProgramacionActividad_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[ProgramacionActividadDoc] ADD  CONSTRAINT [DF_ProgramacionActividadDoc_Obligatorio]  DEFAULT ((0)) FOR [Obligatorio]
GO
ALTER TABLE [dbo].[ProgramacionActividadEx] ADD  CONSTRAINT [DF_ProgramacionActividadEx_Cantidad]  DEFAULT ((0)) FOR [Cantidad]
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr] ADD  CONSTRAINT [DF_ProgramacionActividadHerr_Cantidad]  DEFAULT ((0)) FOR [Cantidad]
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr] ADD  CONSTRAINT [DF_ProgramacionActividadHerr_Merma]  DEFAULT ((0)) FOR [Merma]
GO
ALTER TABLE [dbo].[ProgramacionActividadProd] ADD  CONSTRAINT [DF_ProgramacionActividadProd_Cantidad]  DEFAULT ((0)) FOR [Cantidad]
GO
ALTER TABLE [dbo].[ProgramacionActividadProd] ADD  CONSTRAINT [DF_ProgramacionActividadProd_Merma]  DEFAULT ((0)) FOR [Merma]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro] ADD  CONSTRAINT [DF_ProgramacionActividadRegistro_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[Recepcion] ADD  CONSTRAINT [DF_Recepcion_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_FechaCrea]  DEFAULT (getdate()) FOR [FechaCrea]
GO
ALTER TABLE [dbo].[UnidadMedida] ADD  CONSTRAINT [DF_UnidadMedida_Base]  DEFAULT ((0)) FOR [Base]
GO
ALTER TABLE [dbo].[AccOpcion]  WITH CHECK ADD  CONSTRAINT [FK_AccOpcion_AccOpcionGrupo] FOREIGN KEY([IdGrupo])
REFERENCES [dbo].[AccOpcionGrupo] ([IdGrupo])
GO
ALTER TABLE [dbo].[AccOpcion] CHECK CONSTRAINT [FK_AccOpcion_AccOpcionGrupo]
GO
ALTER TABLE [dbo].[AccPerfil]  WITH CHECK ADD  CONSTRAINT [FK_AccPerfil_AccUsuario] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[AccPerfil] CHECK CONSTRAINT [FK_AccPerfil_AccUsuario]
GO
ALTER TABLE [dbo].[AccPerfilOpcion]  WITH CHECK ADD  CONSTRAINT [FK_AccPerfilOpcion_AccOpcion] FOREIGN KEY([IdOpcion])
REFERENCES [dbo].[AccOpcion] ([IdOpcion])
GO
ALTER TABLE [dbo].[AccPerfilOpcion] CHECK CONSTRAINT [FK_AccPerfilOpcion_AccOpcion]
GO
ALTER TABLE [dbo].[AccPerfilOpcion]  WITH CHECK ADD  CONSTRAINT [FK_AccPerfilOpcion_AccPerfil1] FOREIGN KEY([IdPerfil])
REFERENCES [dbo].[AccPerfil] ([IdPerfil])
GO
ALTER TABLE [dbo].[AccPerfilOpcion] CHECK CONSTRAINT [FK_AccPerfilOpcion_AccPerfil1]
GO
ALTER TABLE [dbo].[AccUsuario]  WITH CHECK ADD  CONSTRAINT [FK_AccUsuario_AccUsuarioTipo] FOREIGN KEY([IdUsuarioTipo])
REFERENCES [dbo].[AccUsuarioTipo] ([Id])
GO
ALTER TABLE [dbo].[AccUsuario] CHECK CONSTRAINT [FK_AccUsuario_AccUsuarioTipo]
GO
ALTER TABLE [dbo].[AccUsuarioOpcion]  WITH CHECK ADD  CONSTRAINT [FK_AccUsuarioOpcion_AccOpcion] FOREIGN KEY([IdOpcion])
REFERENCES [dbo].[AccOpcion] ([IdOpcion])
GO
ALTER TABLE [dbo].[AccUsuarioOpcion] CHECK CONSTRAINT [FK_AccUsuarioOpcion_AccOpcion]
GO
ALTER TABLE [dbo].[AccUsuarioOpcion]  WITH CHECK ADD  CONSTRAINT [FK_AccUsuarioOpcion_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[AccUsuarioOpcion] CHECK CONSTRAINT [FK_AccUsuarioOpcion_AccUsuario]
GO
ALTER TABLE [dbo].[Actividad]  WITH CHECK ADD  CONSTRAINT [FK_Actividad_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Actividad] CHECK CONSTRAINT [FK_Actividad_AccUsuario]
GO
ALTER TABLE [dbo].[Actividad]  WITH CHECK ADD  CONSTRAINT [FK_Actividad_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Actividad] CHECK CONSTRAINT [FK_Actividad_AccUsuario1]
GO
ALTER TABLE [dbo].[ActividadCategoria]  WITH CHECK ADD  CONSTRAINT [FK_ActividadCategoria_Actividad] FOREIGN KEY([IdActividad])
REFERENCES [dbo].[Actividad] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActividadCategoria] CHECK CONSTRAINT [FK_ActividadCategoria_Actividad]
GO
ALTER TABLE [dbo].[ActividadCategoria]  WITH CHECK ADD  CONSTRAINT [FK_ActividadCategoria_CategoriaProducto] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[CategoriaProducto] ([Id])
GO
ALTER TABLE [dbo].[ActividadCategoria] CHECK CONSTRAINT [FK_ActividadCategoria_CategoriaProducto]
GO
ALTER TABLE [dbo].[ActividadHerramienta]  WITH CHECK ADD  CONSTRAINT [FK_ActividadHerramienta_Actividad] FOREIGN KEY([IdActividad])
REFERENCES [dbo].[Actividad] ([Id])
GO
ALTER TABLE [dbo].[ActividadHerramienta] CHECK CONSTRAINT [FK_ActividadHerramienta_Actividad]
GO
ALTER TABLE [dbo].[ActividadHerramienta]  WITH CHECK ADD  CONSTRAINT [FK_ActividadHerramienta_HerramientaCategoria] FOREIGN KEY([IdCategoriaH])
REFERENCES [dbo].[HerramientaCategoria] ([Id])
GO
ALTER TABLE [dbo].[ActividadHerramienta] CHECK CONSTRAINT [FK_ActividadHerramienta_HerramientaCategoria]
GO
ALTER TABLE [dbo].[ActividadProducto]  WITH CHECK ADD  CONSTRAINT [FK_ActividadProducto_Actividad] FOREIGN KEY([IdActividad])
REFERENCES [dbo].[Actividad] ([Id])
GO
ALTER TABLE [dbo].[ActividadProducto] CHECK CONSTRAINT [FK_ActividadProducto_Actividad]
GO
ALTER TABLE [dbo].[ActividadProducto]  WITH CHECK ADD  CONSTRAINT [FK_ActividadProducto_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[ActividadProducto] CHECK CONSTRAINT [FK_ActividadProducto_Producto]
GO
ALTER TABLE [dbo].[AsignacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_AsignacionActividad_ProgramacionActividad] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
GO
ALTER TABLE [dbo].[AsignacionActividad] CHECK CONSTRAINT [FK_AsignacionActividad_ProgramacionActividad]
GO
ALTER TABLE [dbo].[Bodega]  WITH CHECK ADD  CONSTRAINT [FK_Bodega_Lugar] FOREIGN KEY([IdLugar])
REFERENCES [dbo].[Lugar] ([Id])
GO
ALTER TABLE [dbo].[Bodega] CHECK CONSTRAINT [FK_Bodega_Lugar]
GO
ALTER TABLE [dbo].[Ensayo]  WITH CHECK ADD  CONSTRAINT [FK_Ensayo_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Ensayo] CHECK CONSTRAINT [FK_Ensayo_AccUsuario]
GO
ALTER TABLE [dbo].[Ensayo]  WITH CHECK ADD  CONSTRAINT [FK_Ensayo_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Ensayo] CHECK CONSTRAINT [FK_Ensayo_AccUsuario1]
GO
ALTER TABLE [dbo].[Ensayo]  WITH CHECK ADD  CONSTRAINT [FK_Ensayo_Especie] FOREIGN KEY([IdEspecie])
REFERENCES [dbo].[Especie] ([Id])
GO
ALTER TABLE [dbo].[Ensayo] CHECK CONSTRAINT [FK_Ensayo_Especie]
GO
ALTER TABLE [dbo].[Ensayo]  WITH CHECK ADD  CONSTRAINT [FK_Ensayo_Lugar] FOREIGN KEY([IdLugar])
REFERENCES [dbo].[Lugar] ([Id])
GO
ALTER TABLE [dbo].[Ensayo] CHECK CONSTRAINT [FK_Ensayo_Lugar]
GO
ALTER TABLE [dbo].[Ensayo]  WITH CHECK ADD  CONSTRAINT [FK_Ensayo_Temporada] FOREIGN KEY([IdTemporada])
REFERENCES [dbo].[Temporada] ([Id])
GO
ALTER TABLE [dbo].[Ensayo] CHECK CONSTRAINT [FK_Ensayo_Temporada]
GO
ALTER TABLE [dbo].[EnsayoDoc]  WITH CHECK ADD  CONSTRAINT [FK_EnsayoDoc_Ensayo] FOREIGN KEY([IdEnsayo])
REFERENCES [dbo].[Ensayo] ([Id])
GO
ALTER TABLE [dbo].[EnsayoDoc] CHECK CONSTRAINT [FK_EnsayoDoc_Ensayo]
GO
ALTER TABLE [dbo].[EnsayoFechaSiembra]  WITH CHECK ADD  CONSTRAINT [FK_EnsayoFechaSiembra_Ensayo] FOREIGN KEY([IdEnsayo])
REFERENCES [dbo].[Ensayo] ([Id])
GO
ALTER TABLE [dbo].[EnsayoFechaSiembra] CHECK CONSTRAINT [FK_EnsayoFechaSiembra_Ensayo]
GO
ALTER TABLE [dbo].[Especie]  WITH CHECK ADD  CONSTRAINT [FK_Especie_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Especie] CHECK CONSTRAINT [FK_Especie_AccUsuario]
GO
ALTER TABLE [dbo].[Especie]  WITH CHECK ADD  CONSTRAINT [FK_Especie_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Especie] CHECK CONSTRAINT [FK_Especie_AccUsuario1]
GO
ALTER TABLE [dbo].[Existencia]  WITH CHECK ADD  CONSTRAINT [FK_Existencia_Herramientas] FOREIGN KEY([IdHerramienta])
REFERENCES [dbo].[Herramientas] ([Id])
GO
ALTER TABLE [dbo].[Existencia] CHECK CONSTRAINT [FK_Existencia_Herramientas]
GO
ALTER TABLE [dbo].[Existencia]  WITH CHECK ADD  CONSTRAINT [FK_Existencia_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[Existencia] CHECK CONSTRAINT [FK_Existencia_Producto]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_AccUsuario] FOREIGN KEY([IdUsuarioCrea])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_AccUsuario]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_AccUsuario1]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_Ensayo] FOREIGN KEY([IdEnsayo])
REFERENCES [dbo].[Ensayo] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_Ensayo]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_HallazgoAsunto] FOREIGN KEY([IdHallazgoAsunto])
REFERENCES [dbo].[HallazgoAsunto] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_HallazgoAsunto]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_HallazgoEstado] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[HallazgoEstado] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_HallazgoEstado]
GO
ALTER TABLE [dbo].[Hallazgo]  WITH CHECK ADD  CONSTRAINT [FK_Hallazgo_HallazgoTipo] FOREIGN KEY([IdTipoHallazgo])
REFERENCES [dbo].[HallazgoTipo] ([Id])
GO
ALTER TABLE [dbo].[Hallazgo] CHECK CONSTRAINT [FK_Hallazgo_HallazgoTipo]
GO
ALTER TABLE [dbo].[HallazgoComentario]  WITH CHECK ADD  CONSTRAINT [FK_HallazgoComentario_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[HallazgoComentario] CHECK CONSTRAINT [FK_HallazgoComentario_AccUsuario]
GO
ALTER TABLE [dbo].[HallazgoComentario]  WITH CHECK ADD  CONSTRAINT [FK_HallazgoComentario_Hallazgo] FOREIGN KEY([IdHallazgo])
REFERENCES [dbo].[Hallazgo] ([Id])
GO
ALTER TABLE [dbo].[HallazgoComentario] CHECK CONSTRAINT [FK_HallazgoComentario_Hallazgo]
GO
ALTER TABLE [dbo].[HallazgoImagen]  WITH CHECK ADD  CONSTRAINT [FK_HallazgoImagen_Hallazgo] FOREIGN KEY([IdHallazgo])
REFERENCES [dbo].[Hallazgo] ([Id])
GO
ALTER TABLE [dbo].[HallazgoImagen] CHECK CONSTRAINT [FK_HallazgoImagen_Hallazgo]
GO
ALTER TABLE [dbo].[Herramientas]  WITH CHECK ADD  CONSTRAINT [FK_Herramientas_HerramientaCategoria] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[HerramientaCategoria] ([Id])
GO
ALTER TABLE [dbo].[Herramientas] CHECK CONSTRAINT [FK_Herramientas_HerramientaCategoria]
GO
ALTER TABLE [dbo].[Lugar]  WITH CHECK ADD  CONSTRAINT [FK_Lugar_Temporada] FOREIGN KEY([IdTemporada])
REFERENCES [dbo].[Temporada] ([Id])
GO
ALTER TABLE [dbo].[Lugar] CHECK CONSTRAINT [FK_Lugar_Temporada]
GO
ALTER TABLE [dbo].[Merma]  WITH CHECK ADD  CONSTRAINT [FK_Merma_Bodega] FOREIGN KEY([IdBodega])
REFERENCES [dbo].[Bodega] ([Id])
GO
ALTER TABLE [dbo].[Merma] CHECK CONSTRAINT [FK_Merma_Bodega]
GO
ALTER TABLE [dbo].[Merma]  WITH CHECK ADD  CONSTRAINT [FK_Merma_Herramientas] FOREIGN KEY([IdHerramienta])
REFERENCES [dbo].[Herramientas] ([Id])
GO
ALTER TABLE [dbo].[Merma] CHECK CONSTRAINT [FK_Merma_Herramientas]
GO
ALTER TABLE [dbo].[Merma]  WITH CHECK ADD  CONSTRAINT [FK_Merma_MermaMotivo] FOREIGN KEY([IdMotivo])
REFERENCES [dbo].[MermaMotivo] ([Id])
GO
ALTER TABLE [dbo].[Merma] CHECK CONSTRAINT [FK_Merma_MermaMotivo]
GO
ALTER TABLE [dbo].[Merma]  WITH CHECK ADD  CONSTRAINT [FK_Merma_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[Merma] CHECK CONSTRAINT [FK_Merma_Producto]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_AccUsuario]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Producto]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_AccUsuario] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_AccUsuario]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_CategoriaProducto] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[CategoriaProducto] ([Id])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_CategoriaProducto]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_UnidadMedida] FOREIGN KEY([IdUnidadMedida])
REFERENCES [dbo].[UnidadMedida] ([id])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_UnidadMedida]
GO
ALTER TABLE [dbo].[Programacion]  WITH CHECK ADD  CONSTRAINT [FK_Programacion_AccUsuario] FOREIGN KEY([IdResponsable])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Programacion] CHECK CONSTRAINT [FK_Programacion_AccUsuario]
GO
ALTER TABLE [dbo].[Programacion]  WITH CHECK ADD  CONSTRAINT [FK_Programacion_Ensayo] FOREIGN KEY([IdEnsayo])
REFERENCES [dbo].[Ensayo] ([Id])
GO
ALTER TABLE [dbo].[Programacion] CHECK CONSTRAINT [FK_Programacion_Ensayo]
GO
ALTER TABLE [dbo].[Programacion]  WITH CHECK ADD  CONSTRAINT [FK_Programacion_Lugar] FOREIGN KEY([IdLugar])
REFERENCES [dbo].[Lugar] ([Id])
GO
ALTER TABLE [dbo].[Programacion] CHECK CONSTRAINT [FK_Programacion_Lugar]
GO
ALTER TABLE [dbo].[Programacion]  WITH CHECK ADD  CONSTRAINT [FK_Programacion_ProgramacionEstado] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[ProgramacionEstado] ([Id])
GO
ALTER TABLE [dbo].[Programacion] CHECK CONSTRAINT [FK_Programacion_ProgramacionEstado]
GO
ALTER TABLE [dbo].[Programacion]  WITH CHECK ADD  CONSTRAINT [FK_Programacion_Temporada] FOREIGN KEY([IdTemporada])
REFERENCES [dbo].[Temporada] ([Id])
GO
ALTER TABLE [dbo].[Programacion] CHECK CONSTRAINT [FK_Programacion_Temporada]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_Programacion] FOREIGN KEY([IdProgramacion])
REFERENCES [dbo].[Programacion] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_Programacion]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_ProgramacionActividad] FOREIGN KEY([IdPrograActReprogra])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_ProgramacionActividad]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_ProgramacionActividadEstado] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[ProgramacionActividadEstado] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_ProgramacionActividadEstado]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_ProgramacionPrioridad] FOREIGN KEY([IdPrioridad])
REFERENCES [dbo].[ProgramacionPrioridad] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_ProgramacionPrioridad]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_UnidadMedida] FOREIGN KEY([IdMedida])
REFERENCES [dbo].[UnidadMedida] ([id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_UnidadMedida]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_UnidadMedida1] FOREIGN KEY([IdMedidaValor])
REFERENCES [dbo].[UnidadMedida] ([id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_UnidadMedida1]
GO
ALTER TABLE [dbo].[ProgramacionActividad]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividad_UnidadMedida2] FOREIGN KEY([IdSuperficieObj])
REFERENCES [dbo].[UnidadMedida] ([id])
GO
ALTER TABLE [dbo].[ProgramacionActividad] CHECK CONSTRAINT [FK_ProgramacionActividad_UnidadMedida2]
GO
ALTER TABLE [dbo].[ProgramacionActividadDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadDoc_ProgramacionActividad] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadDoc] CHECK CONSTRAINT [FK_ProgramacionActividadDoc_ProgramacionActividad]
GO
ALTER TABLE [dbo].[ProgramacionActividadEx]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadEx_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadEx] CHECK CONSTRAINT [FK_ProgramacionActividadEx_Producto]
GO
ALTER TABLE [dbo].[ProgramacionActividadEx]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadEx_ProgramacionActividadRegistro] FOREIGN KEY([IdProgramacionActividadRegistro])
REFERENCES [dbo].[ProgramacionActividadRegistro] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadEx] CHECK CONSTRAINT [FK_ProgramacionActividadEx_ProgramacionActividadRegistro]
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadHerr_Herramientas] FOREIGN KEY([IdHerramienta])
REFERENCES [dbo].[Herramientas] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr] CHECK CONSTRAINT [FK_ProgramacionActividadHerr_Herramientas]
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadHerr_ProgramacionActividadRegistro] FOREIGN KEY([IdProgramacionActividadRegistro])
REFERENCES [dbo].[ProgramacionActividadRegistro] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadHerr] CHECK CONSTRAINT [FK_ProgramacionActividadHerr_ProgramacionActividadRegistro]
GO
ALTER TABLE [dbo].[ProgramacionActividadProd]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadProd_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadProd] CHECK CONSTRAINT [FK_ProgramacionActividadProd_Producto]
GO
ALTER TABLE [dbo].[ProgramacionActividadProd]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadProd_ProgramacionActividadRegistro] FOREIGN KEY([IdProgramacionActividadRegistro])
REFERENCES [dbo].[ProgramacionActividadRegistro] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadProd] CHECK CONSTRAINT [FK_ProgramacionActividadProd_ProgramacionActividadRegistro]
GO
ALTER TABLE [dbo].[ProgramacionActividadProducto]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadProducto_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadProducto] CHECK CONSTRAINT [FK_ProgramacionActividadProducto_Producto]
GO
ALTER TABLE [dbo].[ProgramacionActividadProducto]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadProducto_ProgramacionActividadDoc] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividadDoc] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadProducto] CHECK CONSTRAINT [FK_ProgramacionActividadProducto_ProgramacionActividadDoc]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistro_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro] CHECK CONSTRAINT [FK_ProgramacionActividadRegistro_AccUsuario]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividad] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro] CHECK CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividad]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividadMotivo] FOREIGN KEY([IdMotivo])
REFERENCES [dbo].[ProgramacionActividadMotivo] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro] CHECK CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividadMotivo]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividadRegEstado] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[ProgramacionActividadRegEstado] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistro] CHECK CONSTRAINT [FK_ProgramacionActividadRegistro_ProgramacionActividadRegEstado]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistroDoc_EnsayoDoc] FOREIGN KEY([IdEnsayoDoc])
REFERENCES [dbo].[EnsayoDoc] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc] CHECK CONSTRAINT [FK_ProgramacionActividadRegistroDoc_EnsayoDoc]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividad] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc] CHECK CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividad]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividadDoc] FOREIGN KEY([IdProgramacionActividadDoc])
REFERENCES [dbo].[ProgramacionActividadDoc] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc] CHECK CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividadDoc]
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividadRegistro] FOREIGN KEY([IdProgramacionActividadRegistro])
REFERENCES [dbo].[ProgramacionActividadRegistro] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionActividadRegistroDoc] CHECK CONSTRAINT [FK_ProgramacionActividadRegistroDoc_ProgramacionActividadRegistro]
GO
ALTER TABLE [dbo].[ProgramacionDia]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionDia_DiaSemana] FOREIGN KEY([IdDia])
REFERENCES [dbo].[DiaSemana] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionDia] CHECK CONSTRAINT [FK_ProgramacionDia_DiaSemana]
GO
ALTER TABLE [dbo].[ProgramacionDia]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionDia_ProgramacionActividad] FOREIGN KEY([IdProgramacionActividad])
REFERENCES [dbo].[ProgramacionActividad] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProgramacionDia] CHECK CONSTRAINT [FK_ProgramacionDia_ProgramacionActividad]
GO
ALTER TABLE [dbo].[ProgramacionDoc]  WITH CHECK ADD  CONSTRAINT [FK_ProgramacionDoc_Programacion] FOREIGN KEY([IdProgramacion])
REFERENCES [dbo].[Programacion] ([Id])
GO
ALTER TABLE [dbo].[ProgramacionDoc] CHECK CONSTRAINT [FK_ProgramacionDoc_Programacion]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [FK_Recepcion_RecepcionEstado] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[RecepcionEstado] ([Id])
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [FK_Recepcion_RecepcionEstado]
GO
ALTER TABLE [dbo].[RecepcionDet]  WITH CHECK ADD  CONSTRAINT [FK_RecepcionDet_Herramientas] FOREIGN KEY([IdHerramienta])
REFERENCES [dbo].[Herramientas] ([Id])
GO
ALTER TABLE [dbo].[RecepcionDet] CHECK CONSTRAINT [FK_RecepcionDet_Herramientas]
GO
ALTER TABLE [dbo].[RecepcionDet]  WITH CHECK ADD  CONSTRAINT [FK_RecepcionDet_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[RecepcionDet] CHECK CONSTRAINT [FK_RecepcionDet_Producto]
GO
ALTER TABLE [dbo].[RecepcionDet]  WITH CHECK ADD  CONSTRAINT [FK_RecepcionDet_Recepcion] FOREIGN KEY([IdRecepcion])
REFERENCES [dbo].[Recepcion] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RecepcionDet] CHECK CONSTRAINT [FK_RecepcionDet_Recepcion]
GO
ALTER TABLE [dbo].[Temporada]  WITH CHECK ADD  CONSTRAINT [FK_Temporada_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Temporada] CHECK CONSTRAINT [FK_Temporada_AccUsuario]
GO
ALTER TABLE [dbo].[Temporada]  WITH CHECK ADD  CONSTRAINT [FK_Temporada_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Temporada] CHECK CONSTRAINT [FK_Temporada_AccUsuario1]
GO
ALTER TABLE [dbo].[Tratamiento]  WITH CHECK ADD  CONSTRAINT [FK_Tratamiento_AccUsuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Tratamiento] CHECK CONSTRAINT [FK_Tratamiento_AccUsuario]
GO
ALTER TABLE [dbo].[Tratamiento]  WITH CHECK ADD  CONSTRAINT [FK_Tratamiento_AccUsuario1] FOREIGN KEY([IdUsuarioMod])
REFERENCES [dbo].[AccUsuario] ([Id])
GO
ALTER TABLE [dbo].[Tratamiento] CHECK CONSTRAINT [FK_Tratamiento_AccUsuario1]
GO
ALTER TABLE [dbo].[UnidadMedida]  WITH CHECK ADD  CONSTRAINT [FK_UnidadMedida_UnidadMedida] FOREIGN KEY([IdUMBase])
REFERENCES [dbo].[UnidadMedida] ([id])
GO
ALTER TABLE [dbo].[UnidadMedida] CHECK CONSTRAINT [FK_UnidadMedida_UnidadMedida]
GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioCambiarClave]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[AccUsuarioCambiarClave] 
	@Id int,
	@Clave bigint
AS
BEGIN

	Update Usuarios set 
		Clave = @Clave,
		CambiarClave = 0
	Where
		Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioClave]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		   Carlos
-- Create date:  2017-12-27
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AccUsuarioClave]
(
	@IdUsuario int output,
	@Usuario varchar(20),
	@Clave varchar(30),
	@ClaveEncript bigint output
)
AS	
	If @IdUsuario = 0
	BEgin

		Select
				@IdUsuario =  Id,
				@ClaveEncript = Clave
		From  AccUsuario
		Where usu_usuario = @Usuario and Activo = 1
	End
	else
	Begin
		Select
				@IdUsuario =  Id,
				@ClaveEncript = Clave
		From  AccUsuario
		Where Id  = @IdUsuario and Activo = 1
	End
		
	RETURN








GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioExito]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		   Carlos 
-- Create date:  2017-12-28
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AccUsuarioExito]
(
	@IdUsuario int
)
AS	
  Declare @IdUtilizacion int,
	        @TieneVarExtras bit
  
  --Insert into AccUtilizacion with(rowlock)  (IdUsuario, FecEntrada )
  --values (@IdUsuario, GETDATE())
  --Set @IdUtilizacion = SCOPE_IDENTITY()

	SELECT        
		AccUsuario.id,
		--AccUsuario.rut_empleado,
		AccUsuario.nombre_empleado,
		AccUsuario.usu_usuario,
		AccUsuario.Clave,
		AccUsuario.Administrador,
		--AccUsuario.Telefono,
		@IdUtilizacion as IdUtilizacion,
		--Configuracion.IVA,
		AccUsuario.CambiarClave,
		--Configuracion.TiempoDashboard,
		--Configuracion.DiasLlegadaProducto,
		--Configuracion.DiasOSAEmpezar,
		--Configuracion.PorcTerminoOC,
		--Configuracion.DiasOSSinCerrar,
		--Configuracion.MinPickingProceso,
		--Configuracion.ColorSoloLectura,
		--Configuracion.ValorCaja,
		AccUsuario.IdUsuarioTipo,
		AccUsuario.Email
		--,
		--Empresa.rut_empresa,
		--Empresa.ClaveWS
	FROM            
		AccUsuario 
		--Cross join
		--Configuracion cross join
		--Empresa
	WHERE        
		(AccUsuario.Id = @IdUsuario)
    
   Select  IdOpcion, 
           Ver, 
           Editar
   From    AccUsuarioOpcion
   Where   IdUsuario = @IdUsuario

	RETURN









GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec UsuariosIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UsuariosIns%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioIns]
    @Id int output,
    @nombre_empleado varchar (20),
    @usu_usuario nvarchar(100),
    @Clave bigint = null,
    @Administrador bit,
    @IdUsuarioTipo int,
    @Email varchar (150) = null,
    --@Telefono varchar (30) = null,
    @Celular varchar (30) = null,
    @Observacion varchar (4000) = null,	
	@Activo bit
	--@rut_empleado varchar(100) = null
AS
BEGIN

insert into AccUsuario with(rowlock) (
         nombre_empleado,  usu_usuario,  Clave,  Administrador,  IdUsuarioTipo,  Email,  --Telefono,  
		 Celular,  Observacion, Activo)
    values (
         @nombre_empleado, @usu_usuario, @Clave, @Administrador, @IdUsuarioTipo, @Email, --@Telefono, 
		 @Celular, @Observacion, @Activo)

set @Id = scope_identity()

END












GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioOpcionUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AccUsuarioOpcionUpd]
	@IdUsuario int,
	@IdOpcion int,
	@Ver bit,
	@Editar bit
AS
BEGIN

	Insert into AccUsuarioOpcion with(Rowlock) (IdUsuario, IdOpcion, Ver,Editar)
	Values(@IdUsuario, @IdOpcion, @Ver, @Editar)

END






GO
/****** Object:  StoredProcedure [dbo].[AccUsuariosDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec UsuariosDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UsuariosDel%'
-- --------------------------------
Create Procedure [dbo].[AccUsuariosDel]
    @Id int
AS
BEGIN

delete from AccUsuario with(rowlock)
where Id = @Id

END









GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec UsuariosSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UsuariosSel_Grids%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioSel_Grids]
AS
BEGIN
	SELECT        Id, usu_usuario AS Usuario, nombre_empleado AS Nombre, Activo
	FROM            AccUsuario

END



--	@Orden varchar(100) = null,
--	@Filtro varchar(Max) = null
--AS
--BEGIN

--	DEclare @SQL varchar(Max)

--	if len(@Orden) = 0 
--		set @Orden = 'Id'

--	Set @SQL = '
--	SELECT        Id, usu_usuario AS Usuario, nombre_empleado AS Nombre, CAST(Activo AS int) AS Activo, rut_empleado
--				FROM            AccUsuario
--				'

--	if len(@Filtro) > 0 
--		Set @SQL = @SQL + ' Where ' + @Filtro

--	Exec(@SQL)

--END









GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec UsuariosSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UsuariosSel_Id%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioSel_Id]
    @Id int
AS
BEGIN

	SELECT        Id, nombre_empleado, usu_usuario, Administrador, IdUsuarioTipo, Email, --Telefono,
	 Celular, Observacion, Activo, Identificador --, rut_empleado
	FROM            AccUsuario
	WHERE        (Id = @Id)

	Select * from (
	SELECT        
		AccUsuarioOpcion.IdUsuario, AccOpcion.IdOpcion, AccOpcion.Opcion,
		Isnull(AccUsuarioOpcion.Ver,0) as Ver, Isnull(AccUsuarioOpcion.Editar,0) as Editar,
		AccOpcion.Accion,AccOpcion.Observaciones, AccOpcion.IdGrupo, AccOpcionGrupo.Orden
	FROM AccUsuarioOpcion 
	RIGHT OUTER JOIN AccOpcion ON AccUsuarioOpcion.IdOpcion = AccOpcion.IdOpcion And AccUsuarioOpcion.IdUsuario = @Id 
	inner join AccOpcionGrupo on AccOpcion.IdGrupo = AccOpcionGrupo.IdGrupo
	Union all
	Select 0 as IdUsuario, null as IdOpcion, Grupo as Opcion, cast(0 as bit) as Ver, cast(0 as bit) as Editar,
	 -1 as Accion, '' as Observaciones, IdGrupo, Orden  from AccOpcionGrupo
	) as T
	Order by 
		Orden, IdGrupo, IdOpcion
END











GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioSel_Identificador]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec AccUsuarioSel_Identificador <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%AccUsuarioSel_Identificador%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioSel_Identificador]
    @Identificador varchar(Max)
AS
BEGIN

	SELECT Id, Email, usu_usuario
	FROM AccUsuario
	where Identificador = @Identificador

END












GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec UsuariosUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UsuariosUpd%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioUpd]
    @Id int,
    @nombre_empleado varchar (80),
    @usu_usuario varchar(100),
    @Administrador bit,
	--@id_perfil int,
    @IdUsuarioTipo int,
    @Email varchar (150) = null,
    --@Telefono varchar (30) = null,
    @Celular varchar (30) = null,
    @Observacion varchar (4000) = null,
	@Activo bit
	--@rut_empleado varchar(100) = null
AS
BEGIN

	--Begin tran

		update AccUsuario with(rowlock) set
			nombre_empleado = @nombre_empleado,
			usu_usuario = @usu_usuario,
			Administrador = @Administrador,
			--id_perfil = @id_perfil,
			IdUsuarioTipo = @IdUsuarioTipo,
			Email = @Email,
			--Telefono = @Telefono,
			Celular = @Celular,
			Observacion = @Observacion,
			Activo = @Activo
			--rut_empleado = @rut_empleado
		where 
			Id = @Id

		--If @@ERROR <> 0 Goto ERROR

		--DElete from AccUsuarioOpcion with(Rowlock)
		--Where IdUsuario = @Id
		--If @@ERROR <> 0 Goto ERROR

		--DElete from AccUsuarioPlanta with(Rowlock)
		--Where IdUsuario = @Id
		--If @@ERROR <> 0 Goto ERROR


--	Commit tran
--	Return
--ERROR:
--	Rollback tran
END











GO
/****** Object:  StoredProcedure [dbo].[AccUsuarioUpdClave]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Vane 2020-10-01
-- Llamado desde:   Usuarios
-- Observaciones:   
-- Llamada SQL:     exec AccUsuarioUpdClave <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%AccUsuarioUpdClave%'
-- --------------------------------
CREATE PRocedure [dbo].[AccUsuarioUpdClave]
    @Id int,
    @Clave varchar(50) = null,
	@CambiarClave bit
AS
BEGIN
		if @clave is null
		Begin
			update AccUsuario with(rowlock) set
				CambiarClave = @CambiarClave
			where 
				Id = @Id
		end
		else
		Begin
			update AccUsuario with(rowlock) set
				clave = @Clave,
				CambiarClave = @CambiarClave
			where 
				Id = @Id
		end
		
		
END











GO
/****** Object:  StoredProcedure [dbo].[ActividadDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadDel]
    @id int
AS
BEGIN

begin tran

	delete from ActividadProducto 
	Where
		IDACtividad = @ID
	IF @@Error <> 0 Goto ERROR

	delete from ActividadHerramienta 
	Where
		IDACtividad = @ID
	IF @@Error <> 0 Goto ERROR

	delete from Actividad with(rowlock)
	where id = @id
	IF @@Error <> 0 Goto ERROr

commit tran
return

ERROR: 
Rollback tran

END












GO
/****** Object:  StoredProcedure [dbo].[ActividadesSel_Ddls]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ActividadesSel_Ddls] 
AS
BEGIN
	

	select Nombre from Actividad
	union
	Select Actividad as Nombre from ProgramacionActividad


END
GO
/****** Object:  StoredProcedure [dbo].[ActividadIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadIns]
    @Id int output,
	@Nombre varchar(100),
	@Activo bit,
	@IdUsuario int,
	@Productos varchar(Max),
	@Categoria varchar(Max)

AS
BEGIN

	BEgin tran

		insert into Actividad with(rowlock) (
				 Nombre, Activo, IdUsuario, FechaCrea)
			values (
				@Nombre, @Activo, @IdUsuario, GETDATE())
		If @@ERROR <> 0 Goto ERROR
		
		set @Id = scope_identity()



		if len(isnull(@productos,'')) > 0
		------------------------------------------------
		Begin 

			Insert into ActividadCategoria with(Rowlock) (IdActividad, IdCategoria)
			SELECT @Id, data from [dbo].[Split](@Productos, '|') where data > 0
			If @@ERROR <> 0 Goto ERROR
		End
		------------------------------------------------
		------------------------------------------------
		Begin 

			Insert into ActividadHerramienta with(Rowlock) (IdActividad, IdCategoriaH)
			SELECT @Id, data from [dbo].[Split](@Categoria, '|') where data > 0
			If @@ERROR <> 0 Goto ERROR
		End
		------------------------------------------------

	Commit tran
	return
	END
ERROR:
	rollback tran














GO
/****** Object:  StoredProcedure [dbo].[ActividadProductoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-29
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadProductoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadProductoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadProductoDel]
    @Id int
AS
BEGIN

delete from ActividadProducto with(rowlock)
where Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[ActividadProductoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-29
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadProductoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadProductoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadProductoIns]
    @Id int output,
    @IdActividad int,
    @IdProducto int
AS
BEGIN

insert into ActividadProducto with(rowlock) (
         IdActividad,  IdProducto)
    values (
        @IdActividad, @IdProducto)

set @Id = scope_identity()

END



GO
/****** Object:  StoredProcedure [dbo].[ActividadProductoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-29
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadProductoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadProductoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadProductoSel_Id]
    @Id int
AS
BEGIN

select Id from ActividadProducto

END





GO
/****** Object:  StoredProcedure [dbo].[ActividadProductoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-29
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadProductoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadProductoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadProductoUpd]
    @Id int,
    @IdActividad int,
    @IdProducto int
AS
BEGIN

update ActividadProducto with(rowlock) set
    IdActividad = @IdActividad,
    IdProducto = @IdProducto
where 
    Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[ActividadSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadSel_Grids]
AS
BEGIN

SELECT        Id, Nombre, Activo, IdUsuario, FechaCrea, IdUsuarioMod, FechaMod
FROM            Actividad
ORDER BY Id desc

END









GO
/****** Object:  StoredProcedure [dbo].[ActividadSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadSel_Id] 
	@Id int output
AS
BEGIN

SELECT        Id, Nombre, Activo
FROM            Actividad
WHERE		  Id = @Id


SELECT Id, IdActividad, IdCategoria
FROM ActividadCategoria
WHERE IdActividad=@Id

select Id, IdActividad, IdCategoriaH from ActividadHerramienta where IdActividad = @Id

END












GO
/****** Object:  StoredProcedure [dbo].[ActividadUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Actividad
-- Observaciones:   
-- Llamada SQL:     exec ActividadUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ActividadUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ActividadUpd]
    @Id int, 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuarioMod int,
	@Productos varchar(max),
	@Categorias varchar(max)
	
AS
BEGIN
declare @IdProducto int
	BEGIN TRAN

	update Actividad with(rowlock) set
			Nombre = @Nombre,
			Activo = @Activo,
			IdUsuarioMod = @IdUsuarioMod,
			FechaMod = GETDATE()
		where 
			Id = @Id 
			IF @@Error <> 0 Goto ERROR

-----------------------------------------------------------------------------------------------INCOMPLETO 


					delete from ActividadCategoria where IdActividad =@Id
					
					delete from ActividadHerramienta where IdActividad =@Id

BEGIN
			Insert into ActividadCategoria with(Rowlock) (IdActividad, IdCategoria)
			SELECT @Id, data from [dbo].[Split](@Productos, '|') where data > 0
			If @@ERROR <> 0 Goto ERROR
		End

BEGIN
			Insert into ActividadHerramienta with(Rowlock) (IdActividad, IdCategoriaH)
			SELECT @Id, data from [dbo].[Split](@Categorias, '|') where data > 0
			If @@ERROR <> 0 Goto ERROR
		End

	commit tran
	return

	ERROR: print 'kueck'
	Rollback tran

END




		






GO
/****** Object:  StoredProcedure [dbo].[AsignacionActividadIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Vane 2020-09-16
-- Llamado desde:   AsignacionActividad
-- Observaciones:   
-- Llamada SQL:     exec AsignacionActividadIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%AsignacionActividadIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[AsignacionActividadIns]
    @IdProgramacionActividad int,
    @IdTemporada int,
    @Fecha date,
    @IdLugar int,
	@IdEnsayo int,
	@Usuarios varchar(100)
	
AS
BEGIN
	
	Create TAble #Usuario(
		IdUsuario int
	)

	if len(isnull(@Usuarios,'')) > 0
	BEGIN
		Insert into #Usuario
		Select 
				data as Usuarios
			from dbo.Split(@Usuarios, '|')
			where data > 0
	END

	Begin tran
	
		Delete from AsignacionActividad with(rowlock)
		Where IdProgramacionActividad = @IdProgramacionActividad
		if @@ERROR <> 0 Goto ERROR

		insert into AsignacionActividad with(rowlock) (
							IdProgramacionActividad,  IdTemporada,  Fecha,  IdLugar, IdEnsayo, IdUsuario)
		Select 
			@IdProgramacionActividad, @IdTemporada,  @Fecha, @IdLugar, @IdEnsayo, IdUsuario
		from 
			#Usuario
		if @@ERROR <> 0 Goto ERROR

	Commit tran
	return

ERROR:	
	rollback tran

--	begin tran
--		If (Select count(IdUsuario) from #Usuario) > 0
--		BEgin

--			Declare cur_user cursor for select IdUsuario from #Usuario
--				open cur_user
				
--			fetch next from cur_user into @IdUsuario

--			while @@fetch_status = 0
--				BEgin
--					insert into AsignacionActividad with(rowlock) (
--						IdProgramacionActividad,  IdTemporada,  Fecha,  IdLugar, IdUsuario)
--					values (
--						@IdProgramacionActividad, @IdTemporada, @Fecha, @IdLugar,  @IdUsuario)
--					if @@ERROR <> 0 Goto ERROR
--					set @Id = scope_identity()

--					fetch next from cur_user into @IdUsuario
--				END

--			close cur_user
--			deallocate cur_user

			
--		End

--		Commit tran
--		return	

--		Drop table #Usuario

--ERROR:
--	rollback tran
END
	
GO
/****** Object:  StoredProcedure [dbo].[AsignacionActividadSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-09-15
-- Llamado desde:   AsignacionActividad
-- Observaciones:   
-- Llamada SQL:     exec AsignacionActividadSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%AsignacionActividadSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[AsignacionActividadSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN


Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),
		Id int , 
		Actividad varchar(250),		
		Fecha datetime,
		Temporada varchar(50),
		Lugar varchar(30),		
		Ensayo varchar(30),
		CantidadUsuarios int
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'ProgramacionActividad.Id desc'
  
	Set @Sql = 'SELECT ProgramacionActividad.Id, ProgramacionActividad.Actividad, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ),
					   Temporada.Nombre As Temporada, Lugar.Codigo AS Lugar, Ensayo.Codigo AS Ensayo,
					   Count(AsignacionActividad.Id) As CantidadUsuarios
				FROM   AsignacionActividad right join
					   ProgramacionActividad on AsignacionActividad.IdProgramacionActividad = ProgramacionActividad.Id inner join
					   Programacion on ProgramacionActividad.IdProgramacion = Programacion.Id inner join
					   Temporada on Programacion.IdTemporada = Temporada.Id inner join
					   Lugar on Programacion.IdLugar = Lugar.Id inner join
					   Ensayo on Programacion.IdEnsayo = Ensayo.Id inner join
					   ProgramacionDia on ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		
		Set @Sql = @Sql+' GROUP BY ProgramacionActividad.Id, ProgramacionActividad.Actividad, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ),
						Temporada.Nombre, Lugar.Codigo, Ensayo.Codigo Order By '+@Orden
    
	Insert Into #Tmp (Id, Actividad, Fecha, Temporada, Lugar, Ensayo, CantidadUsuarios)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, Actividad, Fecha, Temporada, Lugar, Ensayo, CantidadUsuarios
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END




GO
/****** Object:  StoredProcedure [dbo].[AsignacionActividadSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AsignacionActividadSel_Id] 
	@Id int
AS
BEGIN

	SELECT  ProgramacionActividad.Id, Programacion.IdTemporada, ProgramacionActividad.FechaDesde,
			Programacion.IdLugar, Programacion.IdEnsayo		
	FROM    ProgramacionActividad  inner join
			Programacion on ProgramacionActividad.IdProgramacion = Programacion.Id inner join
			Temporada on Programacion.IdTemporada = Temporada.Id inner join
			Lugar on Programacion.IdLugar = Lugar.Id
	WHERE   (ProgramacionActividad.Id = @Id)

	SELECT IdUsuario
	FROM AsignacionActividad
	WHERE IdProgramacionActividad = @Id 

END
GO
/****** Object:  StoredProcedure [dbo].[BodegaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vane 2020-12-29
-- Llamado desde:   Bodega
-- Observaciones:   
-- Llamada SQL:     exec BodegaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%BodegaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[BodegaDel]
    @id int
AS
BEGIN

delete from Bodega with(rowlock)
where id = @id

END











GO
/****** Object:  StoredProcedure [dbo].[BodegaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-12-29
-- Llamado desde:   Bodega
-- Observaciones:   
-- Llamada SQL:     exec BodegaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%BodegaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[BodegaIns]
    @Id int output,
	@IdLugar int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuario int
AS
BEGIN

insert into Bodega with(rowlock) (
          IdLugar, Codigo, Nombre, Activo, IdUsuario, FechaCrea)
    values (
        @IdLugar, @Codigo, @Nombre, @Activo, @IdUsuario, GETDATE())

set @Id = scope_identity()

END











GO
/****** Object:  StoredProcedure [dbo].[BodegaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-12-29
-- Llamado desde:   Bodega
-- Observaciones:   
-- Llamada SQL:     exec BodegaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%BodegaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[BodegaSel_Grids]
AS
BEGIN

	SELECT        Bodega.Id, Bodega.Codigo, Bodega.Nombre, Bodega.Activo, Bodega.IdUsuario, Bodega.FechaCrea, Bodega.IdUsuarioMod, Bodega.FechaMod, Lugar.Nombre AS Lugar
	FROM            Bodega INNER JOIN
							 Lugar ON Bodega.IdLugar = Lugar.Id
	ORDER BY Bodega.Codigo

END










GO
/****** Object:  StoredProcedure [dbo].[BodegaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-12-29
-- Llamado desde:   Bodega
-- Observaciones:   
-- Llamada SQL:     exec BodegaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%BodegaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[BodegaSel_Id]
	@Id int output
AS
BEGIN

SELECT        Id, IdLugar, Codigo, Nombre, Activo
FROM            Bodega
WHERE		  Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[BodegaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-12-29
-- Llamado desde:   Bodega
-- Observaciones:   
-- Llamada SQL:     exec BodegaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%BodegaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[BodegaUpd]
    @Id int,
	@IdLugar int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuarioMod int
AS
BEGIN

update Bodega with(rowlock) set
	@IdLugar = @IdLugar,
    Codigo = @Codigo,
	Nombre = @Nombre,
	Activo = @Activo,
	IdUsuarioMod = @IdUsuarioMod,
	FechaMod = GETDATE()
where 
    Id = @Id

END











GO
/****** Object:  StoredProcedure [dbo].[CacheAccOpcionGrupo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-05-24
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheAccOpcionGrupo 
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheAccOpcionGrupo]
AS
BEGIN

Select null As IdGrupo,' ' As Grupo,0 As Orden
Union
Select 
	IdGrupo,
Grupo,
Orden

From 
	AccOpcionGrupo

END
GO
/****** Object:  StoredProcedure [dbo].[CacheActividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheActividad
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheActividad]
AS
BEGIN

Select null As Id,' ' As Nombre
Union
Select null, Nombre
From 
	Actividad
union
Select 
	null, Actividad as Nombre
from 
	ProgramacionActividad

END


GO
/****** Object:  StoredProcedure [dbo].[CacheActividadSel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheActividad
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheActividadSel]
	@Buscar varchar(100) = null
AS
BEGIN


Select * from (
	Select null As Id,' ' As Nombre
	Union
	Select null, Nombre
	From 
		Actividad
	union 
	Select 
		null, Actividad as Nombre
	from 
		ProgramacionActividad
) as T 
Where 
	Nombre like '%'+@Buscar+'%'

END


GO
/****** Object:  StoredProcedure [dbo].[CacheBodega]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheBodega
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheBodega]
AS
BEGIN

Select null As Id,' ' As Nombre, null IdLugar
Union
Select Id, Nombre, IdLugar
From 
	Bodega

END



GO
/****** Object:  StoredProcedure [dbo].[CacheCategoria]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProducto
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheCategoria]
AS
BEGIN

Select  null as Id, ' ' as Categoria
Union
Select   Id as Id, Categoria
From 
	CategoriaProducto

END





GO
/****** Object:  StoredProcedure [dbo].[CacheCategoriaHerr]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProducto
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheCategoriaHerr]
AS
BEGIN

Select  null as Id, ' ' as Categoria
Union
Select   Id as Id, Categoria
From 
	HerramientaCategoria

END





GO
/****** Object:  StoredProcedure [dbo].[CacheDia]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheDia
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheDia]
AS
BEGIN

Select null As Id,' ' As Dia
Union
Select Id, Dia
From 
	DiaSemana
Order By Id asc

END


GO
/****** Object:  StoredProcedure [dbo].[CacheEnsayo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheEnsayo
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheEnsayo]
AS
BEGIN

Select null As Id, null as Codigo, null as IdTemporada , null as IdLugar, null as IdResponsable
Union
Select Id, Codigo, IdTemporada, IdLugar, IdResponsable
From 
	Ensayo

END




GO
/****** Object:  StoredProcedure [dbo].[CacheEnsayoLugar]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheEnsayo
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheEnsayoLugar]
AS
BEGIN

Select null As Id,' ' As Nombre, null as FechaCosecha, null as IdLugar, 0 as CantTratamiento
Union
Select Id, Codigo, Nombre, FechaCosecha, EnsayoLugar.IdLugar, CantTratamiento
From 
	Ensayo Left join
	EnsayoLugar on Ensayo.Id = EnsayoLugar.IdEnsayo

END


GO
/****** Object:  StoredProcedure [dbo].[CacheEspecie]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheEspecie
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheEspecie]
AS
BEGIN

Select null As Id,' ' As Nombre
Union
Select Id, Nombre
From 
	Especie

END


GO
/****** Object:  StoredProcedure [dbo].[CacheExistencia]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          ROBERTO 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheExistencia
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheExistencia]
AS
BEGIN

Select null As Id,' ' As IdProducto, null Cantidad
Union
Select Id, IdProducto, Cantidad
From 
	Existencia

END


GO
/****** Object:  StoredProcedure [dbo].[CacheHerramienta]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProducto
-- --------------------------------
Create PROCEDURE [dbo].[CacheHerramienta]
AS
BEGIN

Select  null as IdHerramienta, ' ' as Nombre
Union
SELECT        Herramientas.Id AS IdHerramienta, Herramientas.Nombre
FROM            Herramientas 

END





GO
/****** Object:  StoredProcedure [dbo].[CacheIngredienteActivo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CacheIngredienteActivo] 
AS
BEGIN
	

	Select  ' ' as IngredienteActivo
	Union
	Select  IngredienteActivo
	From 
		Producto
	Where
		Len(Isnull(IngredienteActivo,'')) > 0

END


GO
/****** Object:  StoredProcedure [dbo].[CacheLugar]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheLugar
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheLugar]
AS
BEGIN

Select null As Id,' ' As Nombre, null IdTemporada
Union
Select Id, Nombre, IdTemporada
From 
	Lugar

END


GO
/****** Object:  StoredProcedure [dbo].[CacheMermaMotivo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Roberto 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheMermaMotivo
-- --------------------------------
Create PROCEDURE [dbo].[CacheMermaMotivo]
AS
BEGIN

Select null As Id,' ' As Motivo
Union
Select Id, Motivo
From 
	MermaMotivo

END





GO
/****** Object:  StoredProcedure [dbo].[CacheProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProducto
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheProducto]
AS
BEGIN

Select  null as IdProducto, ' ' as Descripcion, null as Nombre
Union
SELECT        Producto.Id AS IdProducto, Producto.Descripcion, UnidadMedida.Nombre
FROM            Producto INNER JOIN
                         UnidadMedida ON Producto.IdUnidadMedida = UnidadMedida.id

END





GO
/****** Object:  StoredProcedure [dbo].[CacheProgramacionActividadMotivo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2020-09-23
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProgramacionActividadMotivo
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheProgramacionActividadMotivo]
AS
BEGIN

Select null As Id,' ' As Motivo
Union
Select Id, Motivo
From 
	ProgramacionActividadMotivo

END


GO
/****** Object:  StoredProcedure [dbo].[CacheProgramacionPrioridad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheProgramacionPrioridad
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheProgramacionPrioridad]
AS
BEGIN

Select null As Id,' ' As Prioridad
Union
Select Id, Prioridad
From 
	ProgramacionPrioridad

END


GO
/****** Object:  StoredProcedure [dbo].[CacheRecepcionEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheRecepcionEstado
-- --------------------------------
create PROCEDURE [dbo].[CacheRecepcionEstado]
AS
BEGIN

Select null As Id,' ' As Estado
Union
Select Id, Estado
From 
	RecepcionEstado

END


GO
/****** Object:  StoredProcedure [dbo].[CacheResponsable]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheResponsable
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheResponsable]
AS
BEGIN

Select null As Id,' ' As nombre_empleado, null as usu_usuario
Union
Select Id, nombre_empleado, usu_usuario
From 
	Accusuario

END


GO
/****** Object:  StoredProcedure [dbo].[CacheTemporada]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheTemporada
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheTemporada]
AS
BEGIN

Select null As Id,' ' As Nombre
Union
Select Id, Nombre
From 
	Temporada

END



GO
/****** Object:  StoredProcedure [dbo].[CacheTratamiento]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheTratamiento
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheTratamiento]
AS
BEGIN

Select null As Id,' ' As Nombre
Union
Select Id, Nombre
From 
	Tratamiento

END


GO
/****** Object:  StoredProcedure [dbo].[CacheUnidadMedida]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheResponsable
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheUnidadMedida]
AS
BEGIN

Select null As Id,' ' As Sigla, null as Nombre, cast(0 as bit) as Base
Union
Select Id, Sigla, Nombre, Base
From 
	UnidadMedida

END



GO
/****** Object:  StoredProcedure [dbo].[CacheUsuario]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheUsuarioPerfil
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheUsuario]
AS
BEGIN

Select null As Id,' ' As Nombre
Union
SELECT        Id, nombre_empleado AS Nombre
	FROM            AccUsuario

END







GO
/****** Object:  StoredProcedure [dbo].[CacheUsuarioPerfil]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vanessa 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheUsuarioPerfil
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheUsuarioPerfil]
AS
BEGIN

Select null As Id,' ' As Perfil
Union
Select IdPerfil As Id, Perfil
From 
	AccPerfil

END





GO
/****** Object:  StoredProcedure [dbo].[CacheUsuarioTipo]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Ariel 2018-01-20
-- Llamado desde:   Cache
-- Observaciones:   
-- Llamada SQL:     exec CacheUsuarioTipo 
-- --------------------------------
CREATE PROCEDURE [dbo].[CacheUsuarioTipo]
AS
BEGIN

Select null As Id,' ' As Tipo
Union
Select 
	Id,Tipo

From 
	AccUsuarioTipo

END


GO
/****** Object:  StoredProcedure [dbo].[CategoriaProductoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2021-01-06
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec CategoriaProductoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%CategoriaProductoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[CategoriaProductoDel]
    @Id int
AS
BEGIN

delete from CategoriaProducto with(rowlock)
where Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[CategoriaProductoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2021-01-06
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec CategoriaProductoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%CategoriaProductoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[CategoriaProductoIns]
    @Id int output,
    @Codigo varchar (150),
    @Categoria varchar (150)
AS
BEGIN

insert into CategoriaProducto with(rowlock) (
         Codigo,  Categoria)
    values (
        @Codigo, @Categoria)

set @Id = scope_identity()

END



GO
/****** Object:  StoredProcedure [dbo].[CategoriaProductoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-06
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec CategoriaProductoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%CategoriaProductoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[CategoriaProductoSel_Grids]
AS
BEGIN

	Select
		Id,codigo,Categoria from CategoriaProducto


END





GO
/****** Object:  StoredProcedure [dbo].[CategoriaProductoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Roberto 2021-01-06
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec CategoriaProductoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%CategoriaProductoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[CategoriaProductoSel_Id]
@Id int
AS
BEGIN

select	Id, Codigo, Categoria 
from	CategoriaProducto 
where	(id =@Id)

END






GO
/****** Object:  StoredProcedure [dbo].[CategoriaProductoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2021-01-06
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec CategoriaProductoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%CategoriaProductoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[CategoriaProductoUpd]
    @Id int,
    @Codigo varchar (150),
    @Categoria varchar (150)
AS
BEGIN

update CategoriaProducto with(rowlock) set
    Codigo = @Codigo,
    Categoria = @Categoria
where 
    Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[ConfiguracionSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Vanessa
-- Create date: 13.09.2020
-- Description:	Configuracion
-- =============================================
CREATE PROCEDURE [dbo].[ConfiguracionSel_Id] 
AS
BEGIN

	SELECT        Id, ServidorSMTP, PuertoSMTP, SSL, UsuarioSMTP, Clave, URLSistema
	 FROM            Configuracion
	
END



GO
/****** Object:  StoredProcedure [dbo].[ConfiguracionUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Configuracion
-- Observaciones:   
-- Llamada SQL:     exec ConfiguracionUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ConfiguracionUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ConfiguracionUpd]
    @Id int,
    @ServidorSMTP varchar(150), 
	@PuertoSMTP int,
	@SSL bit, 
	@UsuarioSMTP varchar(150),
	@Clave varchar(100)
AS
BEGIN

update Configuracion with(rowlock) set
    ServidorSMTP = @ServidorSMTP,
	PuertoSMTP = @PuertoSMTP,
	SSL = @SSL,
	UsuarioSMTP = @UsuarioSMTP,
	Clave = @Clave
where 
    Id = @Id

END











GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividad] 
	@IdUsuario int
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)

	SELECT  distinct     ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, 
					Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                    ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
						 
	Where
		DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @FechaInicio and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin and 
		(ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0)
	order by
		IdProgAct

END
GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividadAtrasadas]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividadAtrasadas] 
	@IdUsuario int
AS
BEGIN


	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)



	SELECT       ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                         ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha 
						 
	Where
		
		 DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @FechaInicio and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin And 
		 (ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0) and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @Hoy

	order by
		IdProgAct

END


GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividadCancelada]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividadCancelada] 
	@IdUsuario int
AS
BEGIN


	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)


	SELECT       ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                         ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha 
						 
	Where
		
		 DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @FechaInicio and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin and
	    ProgramacionActividadRegistro.IdEstado = 2
	order by
		IdProgAct

END
GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividadFutura]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividadFutura] 
	@IdUsuario int
AS
BEGIN


	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)



	SELECT       ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                         ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha 
						 
	Where
		
		 DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= getdate() and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin And 
		 (ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0)

	order by
		IdProgAct

END


GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividadPendiente]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividadPendiente] 
	@IdUsuario int
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(day, 1, @FechaInicio)

	SELECT  distinct     ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, 
					Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                    ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
						 
	Where
		DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < getdate() and 
		(ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0)
	order by
		IdProgAct

END


GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionActividadTerminada]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionActividadTerminada] 
	@IdUsuario int
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)

	SELECT       ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                         ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha 
						 
	Where
		DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @FechaInicio and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin and 
		ProgramacionActividadRegistro.IdEstado = 1
	order by
		IdProgAct

END
GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionProducto] 
	@IdUsuario int
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)

	
	SELECT        
		Producto.Id, Producto.Codigo, Producto.Descripcion, CategoriaProducto.Categoria, T.Cantidad, Producto.Limite
	FROM            
		Producto INNER JOIN
		(
			Select IdProducto, SUM(Cantidad) as Cantidad From Existencia group by IdProducto
		) as T on Producto.Id = T.IdProducto inner join
		CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id 
	Where
		T.Cantidad < Producto.Limite
END


GO
/****** Object:  StoredProcedure [dbo].[DashboardNotificacionProductoVcto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardNotificacionProductoVcto] 
	@IdUsuario int,
	@Tipo int
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)

	if @Tipo = 1
	BEgin

		SELECT        
			Producto.Id, Producto.Codigo, Producto.Descripcion, CategoriaProducto.Categoria, T.FechaVcto, T.Cantidad
		FROM            
			Producto INNER JOIN
			(
				Select IdProducto, FechaVcto, SUM(Cantidad) as Cantidad From Existencia group by IdProducto, FechaVcto
			) as T on Producto.Id = T.IdProducto inner join
			CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id 
		Where
			T.FechaVcto > getdate()
	End
	Else
	begin
		SELECT        
			Producto.Id, Producto.Codigo, Producto.Descripcion, CategoriaProducto.Categoria, T.FechaVcto, T.Cantidad
		FROM            
			Producto INNER JOIN
			(
				Select IdProducto, FechaVcto, SUM(Cantidad) as Cantidad From Existencia group by IdProducto, FechaVcto
			) as T on Producto.Id = T.IdProducto inner join
			CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id 
		Where
			T.FechaVcto > getdate()
	End
END


GO
/****** Object:  StoredProcedure [dbo].[DashboardSelCalendario]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DashboardSelCalendario] 
	@IdUsuario int
AS
BEGIN

	--SELECT        Programacion.Id, Ensayo.Codigo AS CodEnsayo, '''' as CodEspecie, Lugar.Codigo AS CodLugar, AccUsuario.usu_usuario AS Responsable, AccUsuario_1.nombre_empleado AS UsuarioCrea,
	--ProgramacionActividad.FechaDesde, ProgramacionActividad.FechaHasta, ProgramacionActividad.Actividad
	--FROM            Programacion INNER JOIN
	--						 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
	--						 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
	--						 AccUsuario ON Programacion.IdResponsable = AccUsuario.Id INNER JOIN
	--						 AccUsuario AS AccUsuario_1 ON Programacion.IdUsuario = AccUsuario_1.Id inner join
	--						 ProgramacionActividad on Programacion.Id = ProgramacionActividad.IdProgramacion



SELECT      ProgramacionDia.Id,  Programacion.Id AS IdProg, ProgramacionActividad.Id AS IdProgAct, Temporada.Nombre, Ensayo.Codigo AS CodEns, Lugar.Codigo AS CodLugar, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
                         ProgramacionActividad.FechaHasta, DiaSemana.Dia,  DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia, Isnull(ProgramacionActividadRegistro.IdEstado,0) as IdEstado
FROM            Programacion INNER JOIN
                         ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
                         ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
                         DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
						 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
						 

order by
	IdProgAct

END
GO
/****** Object:  StoredProcedure [dbo].[DashboardSelResumen]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashboardSelResumen]
AS
BEGIN

	Declare @Hoy date = getdate()
	
	Declare @FechaInicio date = dateadd(day, (day(@hoy) * -1) + 1, @hoy)

	Declare @FechaFin date = dateadd(month, 1, @FechaInicio)


	
	SELECT      
                Count(ProgramacionDia.Id) as Total, Isnull(Sum(Case when (ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0) and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @Hoy then 1 else 0 end) ,0) as Atrasadas,
				Isnull(Sum(Case when ProgramacionActividadRegistro.IdEstado = 1 then 1 else 0 end),0) as Terminadas,
				Isnull(Sum(Case when ProgramacionActividadRegistro.IdEstado = 2 then 1 else 0 end),0) as Canceladas,
				Isnull(Sum(Case when (ProgramacionActividadRegistro.Id is null or ProgramacionActividadRegistro.IdEstado = 0) and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @Hoy then 1 else 0 end) ,0) as Futuras
FROM            Programacion INNER JOIN
                         ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
                         ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
                         DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
						 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
Where
	DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) >= @FechaInicio and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < @FechaFin
	

	Select 
		Isnull(Sum(Case when T.Cantidad < Producto.Limite then 1 else 0 end),0) as PorAcabar
	from 
		(
			Select IdProducto, SUM(Cantidad) as Cantidad From Existencia group by IdProducto
		) as T inner join
		Producto on T.IdProducto = Producto.Id Inner join
		CategoriaProducto on Producto.IdCategoria = CategoriaProducto.Id

	Select 
		Isnull(Sum(Case when T.FechaVcto > getdate() then 1 else 0 end),0) as PorVencer,
		Isnull(Sum(Case when T.FechaVcto > getdate() then 1 else 0 end),0) as Vencidos
	from 
		(
			Select IdProducto, FechaVcto, SUM(Cantidad) as Cantidad From Existencia group by IdProducto, FechaVcto
		) as T inner join
		Producto on T.IdProducto = Producto.Id Inner join
		CategoriaProducto on Producto.IdCategoria = CategoriaProducto.Id

END


GO
/****** Object:  StoredProcedure [dbo].[DocProgramacionActividadSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[DocProgramacionActividadSel_Grids]
	@IdProgramacionActividad int
AS
BEGIN

	SELECT  Id, Archivo, Descripcion, Documento, Obligatorio
	FROM    ProgramacionActividadDoc
	Where	IdProgramacionActividad = @IdProgramacionActividad

END





GO
/****** Object:  StoredProcedure [dbo].[EnsayoClonarIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-11-27
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoClonarIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoClonarIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoClonarIns]
    @Id int output,
	@IdEnsayoRel int,
	@IdTemporada int,
	@IdEspecie int,
    @Codigo varchar(30), 
	@Nombre varchar(100),
	@IdResponsable int,
	@Activo bit, 	
	@CantTratamiento int,
	@CantRepeticion int,
	@CantCosechas int,
	@IdUsuario int,
	@IdLugar int
AS
BEGIN
	--Se obtiene el número de versión del Ensayo
	Declare @Version int = 0;

	Select @Version = @Version + Ensayo.NumeroVersion
	from Ensayo
	where Id = @IdEnsayoRel;

	--Se inserta clón
	insert into Ensayo with(rowlock) (
				IdTemporada, IdEspecie, Codigo, Nombre, IdResponsable, Activo, CantTratamiento, CantRepeticion, CantCosechas, IdEnsayoRel, IdUsuario, FechaCrea, IdLugar, NumeroVersion)
		values (
			@IdTemporada, @IdEspecie, @Codigo, @Nombre, @IdResponsable, @Activo, @CantTratamiento,	@CantRepeticion, @CantCosechas, @IdEnsayoRel, @IdUsuario, GETDATE(), @IdLugar, @Version)

	set @Id = scope_identity()
	
	--Se deja inactivo código anterior		
	Update Ensayo
	set Activo = 0
	where Id = 	@IdEnsayoRel;

	--Se clonan los EnsayoDoc
	Insert into EnsayoDoc (IdEnsayo, Nombre, NombreArchivo, Archivo, Obligatorio)
	Select @Id , Nombre, NombreArchivo, Archivo, Obligatorio
	from EnsayoDoc
	where IdEnsayo = @IdEnsayoRel;		

	
	--EnsayoFechaSiembra
	insert into EnsayoFechaSiembra (IdEnsayo, FechaSiembra, Tratamientos)
	Select @Id, FechaSiembra, Tratamientos
	from EnsayoFechaSiembraTemp
	where IdEnsayo = @IdEnsayoRel;
 
	delete from EnsayoFechaSiembraTemp where  IdEnsayo = @IdEnsayoRel;

END

GO
/****** Object:  StoredProcedure [dbo].[EnsayoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDel]
    @Id int
AS
BEGIN

delete from Ensayo with(rowlock)
where Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocDel]
    @Id int
AS
BEGIN

delete from EnsayoDoc with(rowlock)
where Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocIns]
    @Id int output,
    @IdEnsayo int,
    @Nombre varchar (150),
    @NombreArchivo varchar (150),
    @Archivo image,
	@Obligatorio bit
AS
BEGIN

insert into EnsayoDoc with(rowlock) (
         IdEnsayo,  Nombre,  NombreArchivo,  Archivo, Obligatorio)
    values (
        @IdEnsayo, @Nombre, @NombreArchivo, @Archivo, @Obligatorio)

set @Id = scope_identity()

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocSel_Grids]
	@IdEnsayo int
AS
BEGIN

SELECT        Id, Nombre, NombreArchivo, Obligatorio
FROM            EnsayoDoc
Where IdEnsayo = @IdEnsayo

END



GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, Nombre, NombreArchivo
FROM            EnsayoDoc
WHERE        (Id = @Id)

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocSel_IdDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocSel_IdDoc]
    @Id int
AS
BEGIN

SELECT        Id, Nombre, NombreArchivo, Archivo, Obligatorio
FROM            EnsayoDoc
WHERE        (Id = @Id)

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoDocUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoDocUpd]
    @Id int,
    @IdEnsayo int,
    @Nombre varchar (150),
    @NombreArchivo varchar (150),
    @Archivo image
AS
BEGIN

update EnsayoDoc with(rowlock) set
    IdEnsayo = @IdEnsayo,
    Nombre = @Nombre,
    NombreArchivo = @NombreArchivo,
    Archivo = @Archivo
where 
    Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoDocSel_Grids%'
-- --------------------------------
Create PROCEDURE [dbo].[EnsayoFechaSel_Grids]
	@IdEnsayo int
AS
BEGIN

	SELECT        Id, FechaSiembra, Tratamientos
	FROM            EnsayoFechaSiembra
	WHERE        (IdEnsayo = @IdEnsayo)

END



GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraDel]
    @Id int
AS
BEGIN

delete from EnsayoFechaSiembra with(rowlock)
where Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraIns]
    @Id int output,
    @IdEnsayo int,
    @FechaSiembra date,
    @Tratamientos varchar (150) = null
AS
BEGIN

insert into EnsayoFechaSiembra with(rowlock) (
         IdEnsayo,  FechaSiembra,  Tratamientos)
    values (
        @IdEnsayo, @FechaSiembra, @Tratamientos)

set @Id = scope_identity()

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraSel_Grids]
	@IdEnsayo int
AS
BEGIN

SELECT        Id, IdEnsayo, FechaSiembra, Tratamientos
FROM            EnsayoFechaSiembra
WHERE        (IdEnsayo = @IdEnsayo)

END



GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, IdEnsayo, FechaSiembra, Tratamientos
FROM            EnsayoFechaSiembra
WHERE        (Id = @Id)

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraTempDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraTempDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraTempDel%'
-- --------------------------------
create PROCEDURE [dbo].[EnsayoFechaSiembraTempDel]
    @Id int
AS
BEGIN

delete from EnsayoFechaSiembraTemp with(rowlock)
where Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraTempIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-12-01
-- Llamado desde:   EnsayoFechaSiembraTemp
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraTempIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraTempIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraTempIns]
    @Id int output,
    @IdEnsayo int,
    @FechaSiembra date,
    @Tratamientos varchar (150) = null
AS
BEGIN

insert into EnsayoFechaSiembraTemp with(rowlock) (
         IdEnsayo,  FechaSiembra,  Tratamientos)
    values (
        @IdEnsayo, @FechaSiembra, @Tratamientos)

set @Id = scope_identity()

END





GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraTempSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraTempSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraTempSel_Grids%'
-- --------------------------------
create PROCEDURE [dbo].[EnsayoFechaSiembraTempSel_Grids]
	@IdEnsayo int
AS
BEGIN

SELECT        Id, IdEnsayo, FechaSiembra, Tratamientos
FROM            EnsayoFechaSiembraTEmp
WHERE        (IdEnsayo = @IdEnsayo)

END



GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraTempSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembTempSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraTempSel_Id%'
-- --------------------------------
create PROCEDURE [dbo].[EnsayoFechaSiembraTempSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, IdEnsayo, FechaSiembra, Tratamientos
FROM            EnsayoFechaSiembraTemp
WHERE        (Id = @Id)

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraTempUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraTempUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraTempUpd%'
-- --------------------------------
create PROCEDURE [dbo].[EnsayoFechaSiembraTempUpd]
    @Id int,
    @IdEnsayo int,
    @FechaSiembra date,
    @Tratamientos varchar (150) = null
AS
BEGIN

update EnsayoFechaSiembraTemp with(rowlock) set
    IdEnsayo = @IdEnsayo,
    FechaSiembra = @FechaSiembra,
    Tratamientos = @Tratamientos
where 
    Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoFechaSiembraUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-11-09
-- Llamado desde:   EnsayoFecha
-- Observaciones:   
-- Llamada SQL:     exec EnsayoFechaSiembraUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoFechaSiembraUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoFechaSiembraUpd]
    @Id int,
    @IdEnsayo int,
    @FechaSiembra date,
    @Tratamientos varchar (150) = null
AS
BEGIN

update EnsayoFechaSiembra with(rowlock) set
    IdEnsayo = @IdEnsayo,
    FechaSiembra = @FechaSiembra,
    Tratamientos = @Tratamientos
where 
    Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoIns]
    @Id int output,
	@IdTemporada int,
	@IdEspecie int,
    @Codigo varchar(30), 
	@Nombre varchar(100),
	@IdResponsable int,
	@Activo bit, 	
	@CantTratamiento int,
	@CantRepeticion int,
	@CantCosechas int,
	@IdUsuario int,
	@IdLugar int
AS
BEGIN
	
	insert into Ensayo with(rowlock) (
				IdTemporada, IdEspecie, Codigo, Nombre, IdResponsable, Activo, CantTratamiento, CantRepeticion, CantCosechas, IdUsuario, FechaCrea, IdLugar, NumeroVersion)
		values (
			@IdTemporada, @IdEspecie, @Codigo, @Nombre, @IdResponsable, @Activo, @CantTratamiento,	@CantRepeticion, @CantCosechas, @IdUsuario, GETDATE(), @IdLugar, 0)

	set @Id = scope_identity()
			
		

END




GO
/****** Object:  StoredProcedure [dbo].[EnsayoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoSel_Grids]
AS
BEGIN

SELECT        Ensayo.Id, Ensayo.Codigo, AccUsuario.usu_usuario as nombre_empleado, Ensayo.Activo, Ensayo.CantTratamiento, Ensayo.CantRepeticion, Ensayo.CantCosechas, Ensayo.IdUsuario, Ensayo.FechaCrea, 
                         Ensayo.IdUsuarioMod, Ensayo.FechaMod, Ensayo.IdTemporada, Especie.Codigo AS Especie, Lugar.Codigo AS CodLugar
FROM            Ensayo INNER JOIN
                         AccUsuario ON Ensayo.IdResponsable = AccUsuario.Id INNER JOIN
                         Especie ON Ensayo.IdEspecie = Especie.Id INNER JOIN
                         Lugar ON Ensayo.IdLugar = Lugar.Id
END









GO
/****** Object:  StoredProcedure [dbo].[EnsayoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoSel_Id]
	@Id int output
AS
BEGIN

	SELECT        
		Id, IdTemporada , IdEspecie, Codigo, Nombre, IdResponsable, Activo, CantTratamiento, CantRepeticion, CantCosechas, Isnull(Doc.CantArchivos,0) as CantArchivos, IdLugar, 
		Isnull(FechasEnsayo.Cantidad,0) as CantFechasEnsayo
	FROM            
		Ensayo left join
		(
			Select IdEnsayo, count(Id) as CantArchivos from EnsayoDoc group by IdEnsayo
		) as Doc On Ensayo.Id = Doc.IdEnsayo Left Outer Join
		(
			Select IdEnsayo, count(Id) as Cantidad from EnsayoFechaSiembra  group by IdEnsayo
		) as FechasEnsayo on Ensayo.id	= FechasEnsayo.IdEnsayo
	WHERE		  Id = @Id

	Select 
		 Id, Nombre
	from 
		EnsayoDoc
	Where
		IdEnsayo = @Id
END









GO
/****** Object:  StoredProcedure [dbo].[EnsayoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Ensayo
-- Observaciones:   
-- Llamada SQL:     exec EnsayoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EnsayoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EnsayoUpd]
    @Id int,
	@IdTemporada int,
	@IdEspecie int,
    @Codigo varchar(30), 
	@Nombre varchar(100),
	@IdResponsable int,
	@Activo bit, 
	@CantTratamiento int, 
	@CantRepeticion int,
	@CantCosechas int,
	@IdUsuarioMod int,
	@IdLugar int
AS
BEGIN

	update Ensayo with(rowlock) set
		IdTemporada = @IdTemporada,
		IdEspecie = @IdEspecie,
		Codigo = @Codigo,
		Nombre = @Nombre,
		IdResponsable = @IdResponsable,
		Activo = @Activo,
		CantTratamiento = @CantTratamiento, 
		CantRepeticion = @CantRepeticion,
		CantCosechas = @CantCosechas,
		IdUsuarioMod = @IdUsuarioMod,
		FechaMod = GETDATE(),
		IdLugar = @IdLugar
	where 
		Id = @Id
		

END










GO
/****** Object:  StoredProcedure [dbo].[EspecieDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Especie
-- Observaciones:   
-- Llamada SQL:     exec EspecieDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EspecieDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EspecieDel]
    @id int
AS
BEGIN

delete from Especie with(rowlock)
where id = @id

END










GO
/****** Object:  StoredProcedure [dbo].[EspecieIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Especie
-- Observaciones:   
-- Llamada SQL:     exec EspecieIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EspecieIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EspecieIns]
    @Id int output,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuario int
AS
BEGIN

insert into Especie with(rowlock) (
         Codigo, Nombre, Activo, IdUsuario, FechaCrea)
    values (
        @Codigo, @Nombre, @Activo, @IdUsuario, GETDATE())

set @Id = scope_identity()

END










GO
/****** Object:  StoredProcedure [dbo].[EspecieSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Especie
-- Observaciones:   
-- Llamada SQL:     exec EspecieSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EspecieSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EspecieSel_Grids]
AS
BEGIN

SELECT        Id, Codigo, Nombre, Activo, IdUsuario, FechaCrea, IdUsuarioMod, FechaMod
FROM            Especie
ORDER BY CODIGO

END









GO
/****** Object:  StoredProcedure [dbo].[EspecieSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Especie
-- Observaciones:   
-- Llamada SQL:     exec EspecieSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EspecieSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EspecieSel_Id]
	@Id int output
AS
BEGIN

SELECT        Id, Codigo, Nombre, Activo
FROM            Especie
WHERE		  Id = @Id

END









GO
/****** Object:  StoredProcedure [dbo].[EspecieUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Especie
-- Observaciones:   
-- Llamada SQL:     exec EspecieUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%EspecieUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[EspecieUpd]
    @Id int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuarioMod int
AS
BEGIN

update Especie with(rowlock) set
    Codigo = @Codigo,
	Nombre = @Nombre,
	Activo = @Activo,
	IdUsuarioMod = @IdUsuarioMod,
	FechaMod = GETDATE()
where 
    Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[EstadoActividadesSel_Excel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EstadoActividadesSel_Excel] 
	@FechaDesde date,
	@FechaHasta date
AS
BEGIN

	SELECT   distinct   DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia,
								DiaSemana.Dia, ProgramacionActividad.Actividad, Temporada.Nombre AS Temporada, 
								Ensayo.Codigo AS Ensayo, Lugar.Nombre AS Lugar,ProgramacionPrioridad.Prioridad,
								ProgramacionActividadRegistro.FechaRealizado, ProgramacionActividadRegEstado.Estado,
								ProgramacionActividadRegistro.Responsables
			FROM            ProgramacionActividad INNER JOIN
								PRogramacion On ProgramacionACtividad.IdProgramacion = Programacion.Id Inner join 
								ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
								DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
								ProgramacionEstado ON ProgramacionActividad.IdEstado = ProgramacionEstado.Id INNER JOIN
								ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id INNER JOIN
								Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
								Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
								Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN 
								ProgramacionActividadRegistro ON ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad INNER JOIN
								ProgramacionActividadRegEstado ON ProgramacionActividadRegistro.IdEstado = ProgramacionActividadRegEstado.Id
WHERE        (ProgramacionActividad.FechaDesde <= @FechaHasta) AND (ProgramacionActividad.FechaHasta >= @FechaDesde)

END

GO
/****** Object:  StoredProcedure [dbo].[ExistenciaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ExistenciaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ExistenciaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ExistenciaDel]
    @Id int
AS
BEGIN

delete from Existencia with(rowlock)
where Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[ExistenciaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ExistenciaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ExistenciaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ExistenciaIns]
    @Id int output,
    @IdProducto int,
    @Cantidad decimal (18,2),
	@IdBodega int
AS
BEGIN

insert into Existencia with(rowlock) (
         IdProducto,  Cantidad, IdBodega)
    values (
        @IdProducto, @Cantidad, @IdBodega)

set @Id = scope_identity()

END



GO
/****** Object:  StoredProcedure [dbo].[ExistenciaMover]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExistenciaMover]
	@Id	int,
	@IdBodega int,
	@Cantidad decimal(18,2)
AS
BEGIN


	if exists(Select 1 From Existencia where Id = @Id and Cantidad < @Cantidad)
	Begin
		raiserror('La cantidad a mover es mayor a la que se encuentra en stock',16,1)
		return
	End
	
	if exists(Select 1 From Existencia where Id = @Id and IdBodega = @IdBodega)
	Begin
		raiserror('No puede mover cantidades hacia la misma bodega a la cual pertenece',16,1)
		return
	End

	declare @IdProducto int, @IdBodegaActual int, @FechaVcto date, @IdHerramienta int, @IdExiste int

	Select @IdProducto = IdProducto, @IdBodegaActual = IdBodega, @FechaVcto = FechaVcto, @IdHerramienta = IdHerramienta from Existencia where id = @Id

	select @IdExiste = Id from Existencia where Isnull(IdProducto,0) = Isnull(@IdProducto,0) and Isnull(IdHerramienta,0) = Isnull(@IdHerramienta,0) and Isnull(FechaVcto,'19000101') = Isnull(@FechaVcto,'19000101') and IdBodega = @IdBodegaActual and Id <> @Id
	
	begin tran

		if @IdExiste is null
		BEgin

		print 'a'
			Insert into Existencia (IdProducto, Cantidad, IdBodega, FEchaVcto, IdHerramienta)
			VAlues (@IdProducto, @Cantidad, @IdBodega, @FechaVcto, @IdHerramienta)
			If @@ERROR <> 0 Goto ERROR
		End
		Else
		BEgin
		print 'b'
			Update Existencia set
				Cantidad = cantidad + @Cantidad
			Where
				Id = @IdExiste
			If @@ERROR <> 0 Goto ERROR
		End
		
		print 'c'
		Update Existencia set 
			Cantidad = Cantidad - @Cantidad
		Where
			Id = @Id
		If @@ERROR <> 0 Goto ERROR

	Commit tran
	return
ERROR:
	rollback tran
END

GO
/****** Object:  StoredProcedure [dbo].[ExistenciaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Roberto 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ExistenciaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ExistenciaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ExistenciaSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN


Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),
		Id int,
		IdProducto int, 
		Descripcion varchar(250), 
		Cantidad int,
		IdBodega int,
		Bodega varchar(100),
		FechaVcto DATE,
		Tipo varchar(100)
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'Existencia.Id'
  
	Set @Sql = 'SELECT        Existencia.Id, Existencia.IdProducto, Isnull(Producto.Descripcion, Herramientas.Nombre) as Descripcion, Existencia.Cantidad, Existencia.IdBodega, Bodega.Nombre AS Bodega, Existencia.FechaVcto,
			Case When Existencia.IdProducto is null then ''Herramienta'' else ''Producto'' end as Tipo
FROM            Existencia INNER JOIN
                         Bodega ON Existencia.IdBodega = Bodega.Id LEFT OUTER JOIN
                         Herramientas ON Existencia.IdHerramienta = Herramientas.Id LEFT OUTER JOIN
                         Producto ON Existencia.IdProducto = Producto.Id
'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		Set @Sql = @Sql+' Order By '+@Orden
    
	Insert Into #Tmp (id,IdProducto, Descripcion, Cantidad, IdBodega, Bodega, FechaVcto, Tipo)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		id,IdProducto, Descripcion, Cantidad, IdBodega, Bodega, FechaVcto, Tipo
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END






GO
/****** Object:  StoredProcedure [dbo].[ExistenciaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ExistenciaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ExistenciaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ExistenciaSel_Id]
    @Id int
AS
BEGIN

	select Existencia.IdProducto, Producto.Descripcion, Existencia.Cantidad, Existencia.IdBodega, Bodega.Nombre as Bodega 
	from existencia inner join 
		producto on Existencia.IdProducto=Producto.Id  inner join
		Bodega on Existencia.IdBodega = Bodega.Id
	order by Producto.Id


END



GO
/****** Object:  StoredProcedure [dbo].[ExistenciaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ExistenciaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ExistenciaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ExistenciaUpd]
    @Id int,
    @IdProducto int,
    @Cantidad decimal (18,2),
	@IdBodega int
AS
BEGIN

update Existencia with(rowlock) set
    IdProducto = @IdProducto,
    Cantidad = @Cantidad,
	IdBodega = @IdBodega
where 
    Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[HallazgoAsuntoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-20
-- Llamado desde:   Hallazgo
-- Observaciones:   
-- Llamada SQL:     exec HallazgoAsuntoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HallazgoAsuntoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HallazgoAsuntoDel]
    @Id int
AS
BEGIN

delete from HallazgoAsunto with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[HallazgoAsuntoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-20
-- Llamado desde:   Hallazgo
-- Observaciones:   
-- Llamada SQL:     exec HallazgoAsuntoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HallazgoAsuntoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HallazgoAsuntoIns]
    @Id int output,
    @Asunto varchar (250),
    @Activo bit
AS
BEGIN

insert into HallazgoAsunto with(rowlock) (
         Asunto,  Activo)
    values (
        @Asunto, @Activo)

set @Id = scope_identity()

END





GO
/****** Object:  StoredProcedure [dbo].[HallazgoAsuntoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-20
-- Llamado desde:   Hallazgo
-- Observaciones:   
-- Llamada SQL:     exec HallazgoAsuntoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HallazgoAsuntoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HallazgoAsuntoSel_Grids]

AS
BEGIN


	Select
		Id,Asunto,Activo From HallazgoAsunto

END





GO
/****** Object:  StoredProcedure [dbo].[HallazgoAsuntoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-20
-- Llamado desde:   Hallazgo
-- Observaciones:   
-- Llamada SQL:     exec HallazgoAsuntoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HallazgoAsuntoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HallazgoAsuntoSel_Id]
    @Id int
AS
BEGIN

select Id,Asunto,Activo from HallazgoAsunto

END







GO
/****** Object:  StoredProcedure [dbo].[HallazgoAsuntoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-20
-- Llamado desde:   Hallazgo
-- Observaciones:   
-- Llamada SQL:     exec HallazgoAsuntoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HallazgoAsuntoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HallazgoAsuntoUpd]
    @Id int,
    @Asunto varchar (250),
    @Activo bit
AS
BEGIN

update HallazgoAsunto with(rowlock) set
    Asunto = @Asunto,
    Activo = @Activo
where 
    Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientaCategoriaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-25
-- Llamado desde:   Herramienta
-- Observaciones:   
-- Llamada SQL:     exec HerramientaCategoriaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientaCategoriaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientaCategoriaDel]
    @Id int
AS
BEGIN

delete from HerramientaCategoria with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientaCategoriaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-25
-- Llamado desde:   Herramienta
-- Observaciones:   
-- Llamada SQL:     exec HerramientaCategoriaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientaCategoriaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientaCategoriaIns]
    @Id int output,
    @Codigo varchar (50),
    @Categoria varchar (150)
AS
BEGIN

insert into HerramientaCategoria with(rowlock) (
         Codigo,  Categoria)
    values (
        @Codigo, @Categoria)

set @Id = scope_identity()

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientaCategoriaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-25
-- Llamado desde:   Herramienta
-- Observaciones:   
-- Llamada SQL:     exec HerramientaCategoriaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientaCategoriaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientaCategoriaSel_Grids]

AS
BEGIN

	Select
		Id,Codigo,Categoria
	From   HerramientaCategoria

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientaCategoriaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-25
-- Llamado desde:   Herramienta
-- Observaciones:   
-- Llamada SQL:     exec HerramientaCategoriaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientaCategoriaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientaCategoriaSel_Id]
    @Id int
AS
BEGIN

select Id,Codigo,Categoria from HerramientaCategoria

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientaCategoriaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-25
-- Llamado desde:   Herramienta
-- Observaciones:   
-- Llamada SQL:     exec HerramientaCategoriaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientaCategoriaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientaCategoriaUpd]
    @Id int,
    @Codigo varchar (50),
    @Categoria varchar (150)
AS
BEGIN

update HerramientaCategoria with(rowlock) set
    Codigo = @Codigo,
    Categoria = @Categoria
where 
    Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientasDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-12
-- Llamado desde:   Herramientas
-- Observaciones:   
-- Llamada SQL:     exec HerramientasDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientasDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientasDel]
    @Id int
AS
BEGIN

delete from Herramientas with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientasIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-12
-- Llamado desde:   Herramientas
-- Observaciones:   
-- Llamada SQL:     exec HerramientasIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientasIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientasIns]
    @Id int output,
    @Codigo varchar (150),
    @Nombre varchar (150),
	@IdCategoria int
AS
BEGIN

insert into Herramientas with(rowlock) (
          Codigo,Nombre, IdCategoria)
    values (
         @Codigo,@Nombre,@IdCategoria)

set @Id = scope_identity()

END





GO
/****** Object:  StoredProcedure [dbo].[HerramientasSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-12
-- Llamado desde:   Herramientas
-- Observaciones:   
-- Llamada SQL:     exec HerramientasSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientasSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientasSel_Grids]

AS
BEGIN

	SELECT        Herramientas.Id, Herramientas.Codigo, Herramientas.Nombre, HerramientaCategoria.Categoria
FROM            Herramientas INNER JOIN
                         HerramientaCategoria ON Herramientas.IdCategoria = HerramientaCategoria.Id


END






GO
/****** Object:  StoredProcedure [dbo].[HerramientasSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-12
-- Llamado desde:   Herramientas
-- Observaciones:   
-- Llamada SQL:     exec HerramientasSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientasSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientasSel_Id]
    @Id int 
AS
BEGIN

select Id, Codigo, Nombre,IdCategoria from Herramientas where id=@Id

END




GO
/****** Object:  StoredProcedure [dbo].[HerramientasUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-12
-- Llamado desde:   Herramientas
-- Observaciones:   
-- Llamada SQL:     exec HerramientasUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%HerramientasUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[HerramientasUpd]
    @Id int,
    @Codigo varchar (150),
    @Nombre varchar (150),
	@IdCategoria int
AS
BEGIN

update Herramientas with(rowlock) set
    Codigo = @Codigo,
    Nombre = @Nombre,
	IdCategoria = @IdCategoria
where 
    Id = @Id

END






GO
/****** Object:  StoredProcedure [dbo].[InformeActividadProducto]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InformeActividadProducto]
AS
	SET NOCOUNT ON;
SELECT        Existencia.IdProducto, Producto.Codigo, Producto.Descripcion, Existencia.Cantidad, Existencia.IdBodega, Bodega.Codigo AS CodigoBodega, Bodega.Nombre AS NombreBodega, Bodega.IdLugar, Lugar.Codigo AS CodigoLugar, Lugar.Nombre AS NombreLugar, 
                         Producto.IdCategoria, CategoriaProducto.Codigo AS CodigoCategoria, CategoriaProducto.Categoria, ActividadProducto.IdActividad, Actividad.Nombre AS NombreActividad
FROM            ActividadProducto INNER JOIN
                         Producto ON ActividadProducto.IdProducto = Producto.Id INNER JOIN
                         CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id INNER JOIN
                         Existencia ON ActividadProducto.IdProducto = Existencia.IdProducto INNER JOIN
                         Bodega ON Existencia.IdBodega = Bodega.Id INNER JOIN
                         Lugar ON Bodega.IdLugar = Lugar.Id INNER JOIN
                         Actividad ON ActividadProducto.IdActividad = Actividad.Id
GO
/****** Object:  StoredProcedure [dbo].[JOB_ProgramacionRegistroActividad_Crear]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[JOB_ProgramacionRegistroActividad_Crear]
	@Fecha date = null
AS
BEGIN


	set @Fecha = isnull(@Fecha, getdate())


	Insert into ProgramacionActividadRegistro with(Rowlock) (IdProgramacionActividad, Fecha, IdEstado, IdUsuario, FechaCrea)


	SELECT      
		ProgramacionActividad.Id, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ), 0, 1, getdate()	
	FROM            Programacion INNER JOIN
							 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
							 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
							 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id left outer join
							 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
						 
	Where
		DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = @Fecha and ProgramacionActividadRegistro.Id is null


END
GO
/****** Object:  StoredProcedure [dbo].[LugarDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Lugar
-- Observaciones:   
-- Llamada SQL:     exec LugarDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%LugarDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[LugarDel]
    @id int
AS
BEGIN

delete from Lugar with(rowlock)
where id = @id

END










GO
/****** Object:  StoredProcedure [dbo].[LugarIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Lugar
-- Observaciones:   
-- Llamada SQL:     exec LugarIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%LugarIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[LugarIns]
    @Id int output,
	@IdTemporada int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuario int
AS
BEGIN

insert into Lugar with(rowlock) (
          IdTemporada, Codigo, Nombre, Activo, IdUsuario, FechaCrea)
    values (
        @IdTemporada, @Codigo, @Nombre, @Activo, @IdUsuario, GETDATE())

set @Id = scope_identity()

END










GO
/****** Object:  StoredProcedure [dbo].[LugarSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Lugar
-- Observaciones:   
-- Llamada SQL:     exec LugarSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%LugarSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[LugarSel_Grids]
AS
BEGIN

	SELECT        Lugar.Id, Lugar.Codigo, Lugar.Nombre, Lugar.Activo, Lugar.IdUsuario, Lugar.FechaCrea, Lugar.IdUsuarioMod, Lugar.FechaMod, Temporada.Nombre AS Temporada
	FROM            Lugar INNER JOIN
							 Temporada ON Lugar.IdTemporada = Temporada.Id
	ORDER BY Lugar.Codigo

END









GO
/****** Object:  StoredProcedure [dbo].[LugarSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Lugar
-- Observaciones:   
-- Llamada SQL:     exec LugarSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%LugarSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[LugarSel_Id]
	@Id int output
AS
BEGIN

SELECT        Id, IdTemporada, Codigo, Nombre, Activo
FROM            Lugar
WHERE		  Id = @Id

END









GO
/****** Object:  StoredProcedure [dbo].[LugarUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Lugar
-- Observaciones:   
-- Llamada SQL:     exec LugarUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%LugarUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[LugarUpd]
    @Id int,
	@IdTemporada int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuarioMod int
AS
BEGIN

update Lugar with(rowlock) set
	IdTemporada = @IdTemporada,
    Codigo = @Codigo,
	Nombre = @Nombre,
	Activo = @Activo,
	IdUsuarioMod = @IdUsuarioMod,
	FechaMod = GETDATE()
where 
    Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[MermaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-27
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaDel]
    @Id int
AS
BEGIN

delete from Merma with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[MermaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-27
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaIns]
    @Id int output,
    @Fecha date,
    @Observacion varchar (max),
    @IdMotivo int,
    @IdProducto int,
    @IdUsuarioCrea int,
    @FechaCrea date,
    @IdUsuarioMod int = null,
    @IdFechaMod date = null
AS
BEGIN

insert into Merma with(rowlock) (
         Fecha,  Observacion,  IdMotivo,  IdProducto,  IdUsuarioCrea,  FechaCrea,  IdUsuarioMod)
    values (
        @Fecha, @Observacion, @IdMotivo, @IdProducto, @IdUsuarioCrea, getdate(), null)

set @Id = scope_identity()

END





GO
/****** Object:  StoredProcedure [dbo].[MermaMotivoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-28
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaMotivoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaMotivoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaMotivoSel_Grids]

AS
BEGIN

	Select
		Id,Motivo
	From  MermaMotivo

END












GO
/****** Object:  StoredProcedure [dbo].[MermaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-27
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaSel_Grids]
	@Filtro varchar(Max) = null
AS
BEGIN

Declare @SQL varchar(MAx) = '

SELECT        Merma.Id, Isnull( Producto.Descripcion, Herramientas.Nombre) as Descripcion , Merma.Observacion, Merma.Fecha, AccUsuario.nombre_empleado AS Nombre, Merma.FechaCrea, MermaMotivo.Motivo
FROM            Merma INNER JOIN
                         AccUsuario ON Merma.IdUsuarioCrea = AccUsuario.Id INNER JOIN
                         MermaMotivo ON Merma.IdMotivo = MermaMotivo.Id LEFT OUTER JOIN
                         Herramientas ON Merma.IdHerramienta = Herramientas.Id LEFT OUTER JOIN
                         Producto ON Merma.IdProducto = Producto.Id
'

If Len(Isnull(@Filtro,'')) > 0
	set @SQL = @SQL + ' Where ' + @Filtro

exec(@SQL)
END





GO
/****** Object:  StoredProcedure [dbo].[MermaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-27
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaSel_Id]
    @Id int
AS
BEGIN

select Id ,  Fecha, Observacion, IdMotivo, IdProducto, IdUsuarioCrea, FechaCrea, IdUsuarioMod from Merma where Id=@Id

END





GO
/****** Object:  StoredProcedure [dbo].[MermaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Roberto 2021-01-27
-- Llamado desde:   Merma
-- Observaciones:   
-- Llamada SQL:     exec MermaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MermaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MermaUpd]
    @Id int,
    @Fecha date,
    @Observacion varchar (max),
    @IdMotivo int,
    @IdProducto int,
    @IdUsuarioMod int = null,
    @IdFechaMod date = null
AS
BEGIN

update Merma with(rowlock) set
    Fecha = @Fecha,
    Observacion = @Observacion,
    IdMotivo = @IdMotivo,
    IdProducto = @IdProducto,
    IdUsuarioMod = @IdUsuarioMod
where 
    Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[MovimientoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec MovimientoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%MovimientoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[MovimientoSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN


Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),
		Id int,
		IdProducto int,
		Descripcion varchar(250),
		Cantidad int,
		Sigla varchar(20),
		FechaVcto date
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'Movimiento.FechaCrea desc'
  
	Set @Sql = 'SELECT        Producto.Id, Producto.Descripcion, Movimiento.Cantidad, UnidadMedida.Sigla, RecepcionDet.FechaVcto
FROM            Movimiento INNER JOIN
                         Producto ON Movimiento.IdProducto = Producto.Id INNER JOIN
                         UnidadMedida ON Producto.IdUnidadMedida = UnidadMedida.id INNER JOIN
                         RecepcionDet ON Producto.Id = RecepcionDet.IdProducto'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		Set @Sql = @Sql+' Order By '+@Orden
    
	Insert Into #Tmp (Id, IdProducto, Descripcion, Cantidad, Sigla,FechaVcto)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, IdProducto, Descripcion, Cantidad, Sigla,FechaVcto
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END






GO
/****** Object:  StoredProcedure [dbo].[ProductoActividadSel_Excel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductoActividadSel_Excel] 
	
AS
BEGIN

	SELECT      Existencia.IdProducto, Producto.Codigo, Producto.Descripcion, Existencia.Cantidad, 
				Existencia.IdBodega, Bodega.Codigo AS CodigoBodega, Bodega.Nombre AS NombreBodega, 
				Bodega.IdLugar, Lugar.Codigo AS CodigoLugar, Lugar.Nombre AS NombreLugar, 
                Producto.IdCategoria, CategoriaProducto.Codigo AS CodigoCategoria, CategoriaProducto.Categoria AS NombreCategoria, 
				ActividadProducto.IdActividad, Actividad.Nombre AS NombreActividad
FROM            ActividadProducto INNER JOIN
                         Producto ON ActividadProducto.IdProducto = Producto.Id LEFT JOIN
                         CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id INNER JOIN
                         Existencia ON ActividadProducto.IdProducto = Existencia.IdProducto INNER JOIN
                         Bodega ON Existencia.IdBodega = Bodega.Id INNER JOIN
                         Lugar ON Bodega.IdLugar = Lugar.Id INNER JOIN
                         Actividad ON ActividadProducto.IdActividad = Actividad.Id

END


GO
/****** Object:  StoredProcedure [dbo].[ProductoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Roberto 2020-12-11
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ProductoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProductoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProductoDel]
    @Id int
AS
BEGIN

delete from Producto with(rowlock)
where Id = @Id

END



GO
/****** Object:  StoredProcedure [dbo].[ProductoExisteSel_Ddl]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductoExisteSel_Ddl] 
AS
BEGIN

	Select null as Id, null as Descripcion
	union all
	Select Id, Descripcion from Producto

END



GO
/****** Object:  StoredProcedure [dbo].[ProductoIngredienteActivoSel_Traer]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProductoIngredienteActivoSel_Traer]

AS
BEGIN


	select distinct IngredienteActivo from Producto where Len(Isnull(IngredienteActivo,'')) > 0
 
END


GO
/****** Object:  StoredProcedure [dbo].[ProductoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Roberto 2020-12-14
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ProductoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProductoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProductoIns]
    @Id int output,
	@Codigo varchar(30),
	@Descripcion varchar (250),
    @IdUnidadMedida int,
    @IdUsuarioCrea int = null,
	@IdCategoria int,
	@Limite decimal(18,2) = null,
	@IngredienteActivo varchar(150) = null
AS
BEGIN

insert into Producto with(rowlock) (
         Codigo, Descripcion,  IdUnidadMedida,  IdUsuarioCrea,IdCategoria, Limite, IngredienteActivo)
    values (
       @Codigo, @Descripcion, @IdUnidadMedida, @IdUsuarioCrea ,@IdCategoria, @Limite, @IngredienteActivo)

set @Id = scope_identity()

END






GO
/****** Object:  StoredProcedure [dbo].[ProductoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Roberto 2020-12-14
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ProductoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProductoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProductoSel_Grids]
	
AS
BEGIN

SELECT        Producto.Id, Producto.Codigo, Producto.Descripcion, UnidadMedida.Sigla, AccUsuario.nombre_empleado AS UsuarioCrea, Producto.FechaCrea, AccUsuario_1.nombre_empleado AS UsuarioMod, Producto.FechaMod, 
                         CategoriaProducto.Categoria, Producto.Limite, Producto.IngredienteActivo
FROM            Producto INNER JOIN
                         UnidadMedida ON Producto.IdUnidadMedida = UnidadMedida.id left JOIN
                         AccUsuario ON Producto.IdUsuarioCrea = AccUsuario.Id LEFT  JOIN
                         CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id LEFT OUTER JOIN
                         AccUsuario AS AccUsuario_1 ON Producto.IdUsuarioMod = AccUsuario_1.Id

END






GO
/****** Object:  StoredProcedure [dbo].[ProductoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Maquina 2020-12-13
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ProductoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProductoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProductoSel_Id]
	@IdProducto int
AS
BEGIN

SELECT        Id,Codigo,Descripcion,IdUnidadMedida, IdUsuarioMod,FechaMod,IdCategoria, Limite, IngredienteActivo
	 FROM            Producto
	 Where Id = @IdProducto
END






GO
/****** Object:  StoredProcedure [dbo].[ProductoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Roberto 2020-12-14
-- Llamado desde:   Producto
-- Observaciones:   
-- Llamada SQL:     exec ProductoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProductoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProductoUpd]
    @Id int,
	@Codigo varchar(30),
    @Descripcion varchar (250),
    @IdUnidadMedida int = null,
    @IdCategoria int = null,
    @IdUsuarioMod int = null,
	@Limite decimal(18,2) = null,
	@IngredienteActivo varchar(150) = null
AS
BEGIN

update Producto with(rowlock) set
	Codigo = @Codigo,
    Descripcion = @Descripcion,
    IdUnidadMedida = @IdUnidadMedida,
    IdCategoria = @IdCategoria,
    IdUsuarioMod = @IdUsuarioMod,
    FechaMod = getdate(),
	limite	 = @limite	,
	IngredienteActivo = @IngredienteActivo
where 
    Id = @Id

END






GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadConsSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-09-24
-- Llamado desde:   ProgramacionActividad
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadConsSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN

SET DATEFIRST 1;

Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),		
		Id int , 
		FechaDia date,
		Dia varchar(30),
		Actividad varchar(250),	
		Temporada varchar(250),	
		Ensayo varchar(250),
		Lugar varchar(250),
		dds varchar(50),
		Responsable varchar(80),
		Prioridad varchar(50),
		IdProgramacion int,
		IdPrioridad int,
		Sel bit,
		FechaDiaTexto varchar(20),
		ProdProgra varchar(MAx),
		HerrProgra varchar(MAx)
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'FechaDia asc'
  
	Set @Sql = 'SELECT        ProgramacionActividad.Id, ProgramacionActividadRegistro.Fecha as FechaDia,
								DiaSemana.Dia, ProgramacionActividad.Actividad, Temporada.Nombre AS Temporada, 
								Ensayo.Codigo AS Ensayo, Lugar.Nombre AS Lugar, ProgramacionActividad.dds,
								AccUsuario.nombre_empleado AS Responsable, ProgramacionPrioridad.Prioridad, 
								Programacion.Id AS IdProgramacion, ProgramacionActividad.IdPrioridad,
								CAST(0 AS bit) AS Sel, Convert(varchar, ProgramacionActividadRegistro.Fecha, 112) as FechaDiaTexto,
								dbo.ConcatenarProductosProgramados(ProgramacionActividadRegistro.Id),
								dbo.ConcatenarHerramientasProgramados(ProgramacionActividadRegistro.Id)
FROM            ProgramacionActividadRegistro INNER JOIN
                         ProgramacionActividad ON ProgramacionActividadRegistro.IdProgramacionActividad = ProgramacionActividad.Id INNER JOIN
                         Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
                         AccUsuario ON Programacion.IdResponsable = AccUsuario.Id INNER JOIN
                         ProgramacionEstado ON Programacion.IdEstado = ProgramacionEstado.Id INNER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
						 DiaSemana On DATEPART(dw,ProgramacionActividadRegistro.Fecha) = DiaSemana.Id Inner join
                         ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id LEFT OUTER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id 

						'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		
		Set @Sql = @Sql+' Order By '+@Orden
    
	print @Sql
	Insert Into #Tmp (Id, FechaDia, Dia, Actividad, Temporada, Ensayo, Lugar, dds, Responsable, Prioridad, IdProgramacion, IdPrioridad, Sel, FechaDiaTexto, ProdProgra, HerrProgra)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, FechaDia, Dia, Actividad, Temporada, Ensayo, Lugar, dds, Responsable, Prioridad, IdProgramacion, IdPrioridad, Sel, FechaDiaTexto, ProdProgra, HerrProgra
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END




GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-04
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadDel]
    @Id int
AS
BEGIN

delete from ProgramacionActividadDoc with(rowlock)
where IdProgramacionActividad = @Id

delete from ProgramacionActividad with(rowlock)
where Id = @Id



END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadDocDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadDocDel]
    @Id int
AS
BEGIN

delete from ProgramacionActividadDoc with(rowlock)
where Id = @Id
END






GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadDocIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadDocIns]
    @Id int output,
    @IdProgramacionActividad int,
    @Archivo varchar (150),
    @Descripcion varchar (150),
    @Documento image,
	@Obligatorio bit
AS
BEGIN

insert into ProgramacionActividadDoc with(rowlock) (
         IdProgramacionActividad,  Archivo,  Descripcion, Documento, Obligatorio )
    values (
        @IdProgramacionActividad, @Archivo, @Descripcion, @Documento, @Obligatorio)

set @Id = scope_identity()

END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadDocSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vane 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadDocSel_Grids]
	@IdProgramacionActividad int output,
	@IdsProgAct varchar(1000) = null,
	@FechaTexto varchar(1000) = null
AS
BEGIN
	Create table #Tmp(
			IdProgramacionActividad int
		)
	
	Insert into #Tmp
	Select * from dbo.Split(@IdsProgAct, '|') 


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@FechaTexto, '|');


	Create table #TmpProgActivDoc (IdProgramacionActividad int, FechaDia date);

	Insert into #TmpProgActivDoc (IdProgramacionActividad, FechaDia)
	SELECT	distinct
			#Tmp.IdProgramacionActividad,
			#Tmp2.Fecha
	FROM 
		#Tmp
		CROSS APPLY #Tmp2;	


    SELECT Archivos.Id, Archivos.IdProgramacionActividad, Archivos.Actividad,
		Archivos.IdProgramacionActividadRegistro,
		Convert(varchar,Archivos.Fecha,112) as FechaTexto, Archivos.Fecha, Archivos.Archivo, 
		Archivos.Descripcion, Archivos.Documento, Archivos.Ensayo, 
		CASE WHEN Archivos.Obligatorio =  1 THEN 'SI' ELSE'NO' END AS Obligatorio, Archivos.Sel
	FROM
		(Select ProgramacionActividadDoc.Id, ProgramacionActividadDoc.IdProgramacionActividad, 
				ProgramacionActividad.Actividad,
				ProgramacionActividadRegistro.Id AS IdProgramacionActividadRegistro,
				ProgramacionActividadRegistro.Fecha, ProgramacionActividadDoc.Descripcion, 
				ProgramacionActividadDoc.Archivo, ProgramacionActividadDoc.Documento, 
				0 as Ensayo, ProgramacionActividadDoc.Obligatorio, CAST(0 AS bit) AS Sel
		from ProgramacionActividadDoc INNER JOIN
			 ProgramacionActividadRegistro ON ProgramacionActividadDoc.IdProgramacionActividad = ProgramacionActividadRegistro.IdProgramacionActividad INNER JOIN
			 ProgramacionActividad on ProgramacionActividadRegistro.IdProgramacionActividad = ProgramacionActividad.Id
		UNION ALL
		 Select EnsayoDoc.Id, ProgramacionActividad.Id AS IdProgramacionActividad,
				ProgramacionActividad.Actividad,
				ProgramacionActividadRegistro.Id AS IdProgramacionActividadRegistro, 
				ProgramacionActividadRegistro.Fecha, EnsayoDoc.NombreArchivo AS Descripcion, 
				EnsayoDoc.Nombre AS Archivo, EnsayoDoc.Archivo AS Documento, 
				1 AS Ensayo, EnsayoDoc.Obligatorio, CAST(0 AS bit) AS Sel
		from Programacion inner join		  
			ProgramacionActividad on Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
			EnsayoDoc on Programacion.IdEnsayo = EnsayoDoc.IdEnsayo INNER JOIN
			ProgramacionActividadRegistro ON ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad
		) Archivos  INNER JOIN 
	 #TmpProgActivDoc ON Archivos.IdProgramacionActividad = #TmpProgActivDoc.IdProgramacionActividad
	 AND Archivos.Fecha = #TmpProgActivDoc.FechaDia

END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadDocSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadDocSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, Archivo AS Nombre, Descripcion AS NombreArchivo, Documento AS Archivo
FROM            ProgramacionActividadDoc
WHERE        (Id = @Id)
UNION ALL
SELECT        Id, Nombre, NombreArchivo, Archivo
FROM            EnsayoDoc
WHERE        (Id = @Id)

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-04
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadIns]
    @Id int output,
    @IdProgramacion int,
    @Actividad varchar (250),
    @FechaDesde date,
    @FechaHasta date,
    @IdPrioridad int,
	@Dias varchar(100),
	@Tratamientos varchar(100) = null,
	@Observacion varchar(1500) = null,
	@Producto varchar(Max) = null,
	@Herramienta varchar(Max) = null,
	@ValorDosis decimal(18,2) = null,
	@IdUM int = null, 
	@IdUMValor int = null,
	@TextoDosis varchar(100) = null
AS
BEGIN

	Declare @DiasText varchar(100)  = ''

	begin tran

		Select 
			data as Dias into #Dias
		from dbo.Split(@Dias, '|')
		where data > 0

		Select 
			@DiasText =  @DiasText + DiaSemana.Dia + ' - '
		from
			#Dias as T inner join
			DiaSemana on T.Dias = DiaSemana.Id

		set @DiasText = left(@DiasText, len(@DiasText) - 2)

		insert into ProgramacionActividad with(rowlock) (
				 IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, Tratamiento, Observacion, ValorDosis, IdMedida, IdMedidaValor, TextoDosis)
			values (
				@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @Tratamientos, @Observacion, @ValorDosis, @IdUM, @IdUMValor, @TextoDosis)
		if @@ERROR <> 0 Goto ERROR
		set @Id = scope_identity()
		
		Insert into ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
		Select 
			Dias, @Id
		from #Dias
		if @@ERROR <> 0 Goto ERROR

		Drop table #Dias
		
		exec ProgramacionRegistroActividad_Crear @Id, @Producto, @Herramienta;

	Commit tran
	return

ERROR:
	rollback tran
END

GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroDocDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-10-28
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroDocDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroDocDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadRegistroDocDel]
    @Id int
AS
BEGIN

delete from ProgramacionActividadRegistroDoc with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroDocIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-10-28
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroDocIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroDocIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadRegistroDocIns]
    @Id int output,
	@IdProgramacionActividadDoc int = null,
	@Ensayo bit,
    @IdProgramacionActividad int,
	@Fecha varchar(1000) = null,
    @Archivo varchar (150),
    @Descripcion varchar (150),
    @Documento image,	
	@IdProgramacionActividadRegistro int
	--@Ids varchar(1000) = null,
	--@IdProgActivReg varchar(1000) = null
AS
BEGIN
	Create table #Tmp(Fecha Date)
	
	Insert into #Tmp
	Select * from dbo.Split(@Fecha, '|') 

	--Create table #Tmp2(IdProgramacionActividadRegistro int)
	
	--Insert into #Tmp2
	--Select * from dbo.Split(@IdProgActivReg, '|') 

	--Create table #TmpProgActivRegDoc (IdProgramacionActividad int, IdProgramacionActividadRegistro int);

	--Insert into #TmpProgActivRegDoc (IdProgramacionActividad, IdProgramacionActividadRegistro)
	--SELECT	distinct
	--		#Tmp.IdProgramacionActividad,
	--		#Tmp2.IdProgramacionActividadRegistro
	--FROM 
	--	#Tmp
	--	CROSS APPLY #Tmp2;	


	--Declare cur_id cursor for Select IdProgramacionActividad, IdProgramacionActividadRegistro from #TmpProgActivRegDoc
	--open cur_id

	--fetch next from cur_id into @IdProgramacionActividad, @IdProgramacionActividadRegistro

		
	--while @@fetch_status = 0
	--BEgin
		Select @IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id 
		from ProgramacionActividadRegistro inner join
			#Tmp on ProgramacionActividadRegistro.Fecha = #Tmp.Fecha
		where ProgramacionActividadRegistro.IdProgramacionActividad = @IdProgramacionActividad
		--and ProgramacionActividadRegistro.Fecha = @Fecha

		if (@Ensayo = 0)
		Begin
			insert into ProgramacionActividadRegistroDoc with(rowlock) (
				 IdProgramacionActividad, IdProgramacionActividadRegistro, IdProgramacionActividadDoc, Archivo,  Descripcion,  Documento)
			values (
				@IdProgramacionActividad, @IdProgramacionActividadRegistro, @IdProgramacionActividadDoc, @Archivo,  @Descripcion,  @Documento)

			set @Id = scope_identity()
		end
		Else
		Begin
			insert into ProgramacionActividadRegistroDoc with(rowlock) (
				 IdProgramacionActividad, IdProgramacionActividadRegistro, IdEnsayoDoc, Archivo,  Descripcion,  Documento)
			values (
				@IdProgramacionActividad, @IdProgramacionActividadRegistro, @IdProgramacionActividadDoc, @Archivo,  @Descripcion,  @Documento)

			set @Id = scope_identity()
		End
		

	--	fetch next from cur_id into @IdProgramacionActividad
	--End
		
	--close cur_id
	--deallocate cur_id
	
END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroDocSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-10-28
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroDocSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadRegistroDocSel_Grids]
	@IdProgramacionActividad int output,
	@IdsProgAct varchar(1000) = null,
	@FechaTexto varchar(1000) = null
AS
BEGIN
	Create table #Tmp(IdProgramacionActividad int)
	
	Insert into #Tmp
	Select * from dbo.Split(@IdsProgAct, '|') 


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@FechaTexto, '|');


	Create table #Tmp3(IdProgActDoc int);
	
	Insert into #Tmp3
	Select ISNULL(ProgramacionActividadRegistroDoc.IdProgramacionActividadDoc,ProgramacionActividadRegistroDoc.IdEnsayoDoc)
	from ProgramacionActividadRegistroDoc INNER JOIN
		 ProgramacionActividadRegistro ON ProgramacionActividadRegistroDoc.IdProgramacionActividad = ProgramacionActividadRegistro.IdProgramacionActividad
					and ProgramacionActividadRegistroDoc.IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id inner join
		 #Tmp ON ProgramacionActividadRegistroDoc.IdProgramacionActividad = #Tmp.IdProgramacionActividad inner join 
		 #Tmp2 ON ProgramacionActividadRegistro.Fecha = #Tmp2.Fecha;
		 

	Create table #TmpProgActivRegDoc (IdProgramacionActividad int, FechaDia date, IdProgramacionActividadDoc int);

	Insert into #TmpProgActivRegDoc (IdProgramacionActividad, FechaDia, IdProgramacionActividadDoc)
	SELECT	#Tmp.IdProgramacionActividad,
			#Tmp2.Fecha,
			#Tmp3.IdProgActDoc
	FROM 
		#Tmp
		CROSS APPLY #Tmp2
		CROSS APPLY #Tmp3;

	
	select  ProgramacionActividadRegistroDoc.Id, ProgramacionActividadRegistroDoc.Archivo, 
			ProgramacionActividadRegistroDoc.Descripcion, ProgramacionActividadRegistro.Id AS IdProgramacionActividadRegistro
	from  ProgramacionActividadRegistroDoc INNER JOIN
			ProgramacionActividadRegistro ON ProgramacionActividadRegistroDoc.IdProgramacionActividad = ProgramacionActividadRegistro.IdProgramacionActividad
			and ProgramacionActividadRegistroDoc.IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id INNER JOIN
			#TmpProgActivRegDoc ON  ProgramacionActividadRegistroDoc.IdProgramacionActividad = #TmpProgActivRegDoc.IdProgramacionActividad
			And ProgramacionActividadRegistro.Fecha = #TmpProgActivRegDoc.FechaDia
			And ((ProgramacionActividadRegistroDoc.IdProgramacionActividadDoc = #TmpProgActivRegDoc.IdProgramacionActividadDoc) 
			or (ProgramacionActividadRegistroDoc.IdEnsayoDoc = #TmpProgActivRegDoc.IdProgramacionActividadDoc));
END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroDocSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-10-28
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroDocSel_Id%'
-- --------------------------------
create PROCEDURE [dbo].[ProgramacionActividadRegistroDocSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, Archivo, Documento
FROM            ProgramacionActividadRegistroDoc
WHERE        (Id = @Id)

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-08-23
-- Llamado desde:   ProgramacionActividadRegistro
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadRegistroIns]
    @Id int output,
	@IdProgramacionActividad int,
	@FechaDia date = null,
	@IdUsuario int,
	@IdEstado int,
	@ObsMotivo varchar(1500) = null,
	@IdMotivo int = null,
	--@FechaReprogra date = null,
	@Ids varchar(1000) = null,
	@Fechas varchar(1000) = null
	
AS
BEGIN
	Create table #Tmp(Id int);

	Insert into #Tmp
	Select * from dbo.Split(@Ids, '|');


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@Fechas, '|');


	Create table #TmpProgActivFecha (IdProgramacionActividad int, FechaDia date);

	Insert into #TmpProgActivFecha (IdProgramacionActividad, FechaDia)
	SELECT	distinct
			#Tmp.Id,
			#Tmp2.Fecha
	FROM 
		#Tmp
		CROSS APPLY #Tmp2;	


	Declare cur_id cursor for Select distinct IdProgramacionActividad, FechaDia from #TmpProgActivFecha
	open cur_id

	fetch next from cur_id into @IdProgramacionActividad, @FechaDia
		
	while @@fetch_status = 0
	BEgin
		--Set Datefirst 1
		--Declare @IdPrograAct int, @DiasText varchar(100)  = '', @FechaDesde date
		--Begin tran
			
			Update ProgramacionActividadRegistro with(rowlock) set				
				IdEstado = @IdEstado,
				ObsMotivo = @ObsMotivo,
				IdMotivo = @IdMotivo,
				IdUsuario = @IdUsuario,
				FechaRealizado = GETDATE()
			where 
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia

			--insert into ProgramacionActividadRegistro with(rowlock) (
			--		 IdProgramacionActividad, Fecha, IdEstado, ObsMotivo, IdMotivo, IdUsuario, FechaCrea)
			--	values (
			--		@IdProgramacionActividad, cast(@FechaDia as date), @IdEstado, @ObsMotivo, @IdMotivo, @IdUsuario, GETDATE());



			--If @@ERROR <> 0 Goto ERROR
			--set @Id = scope_identity()


			--if @FechaReprogra is not null
			--Begin
			--	Select @IdPrograAct = Id From ProgramacionActividad where FechaDesde <= @FechaReprogra and FechaHasta >= @FechaReprogra

			--	if @IdPrograAct <> @IdProgramacionActividad
			--	begin

			--		set @FechaDesde = DATEADD(day, (datepart(dw, getdate()) -1) * -1, getdate())

			--		Insert into ProgramacionActividad with(Rowlock) (IdProgramacion, Actividad, FechaDesde, FechaHasta, IdEstado, IdPrioridad)
			--		Select 
			--			IdProgramacion, Actividad, @FechaDesde, DATEADD(day, 5, @FechaDesde), 1 , 1
			--		from 
			--			ProgramacionActividad 
			--		where 
			--			Id = @IdProgramacionActividad
			--		If @@ERROR <> 0 Goto ERROR

			--		set @IdProgramacionActividad = scope_identity()
			--	End

			
			--	Insert into ProgramacionDia with(Rowlock) (IdProgramacionActividad, IdDia)
			--	Values (@IdProgramacionActividad, datepart(dw, @FechaReprogra))
			--	If @@ERROR <> 0 Goto ERROR
				
			--	Select 
			--		@DiasText =  @DiasText + DiaSemana.Dia + ' - '
			--	from
			--		ProgramacionDia as T inner join
			--		DiaSemana on T.IdDia = DiaSemana.Id
			--	Where
			--		T.IdProgramacionActividad = @IdProgramacionActividad

			--	set @DiasText = left(@DiasText, len(@DiasText) - 2)

			--	Update ProgramacionActividad with(Rowlock) Set
			--		Dias = @DiasText
			--	Where
			--		Id = @IdProgramacionActividad
			--	If @@ERROR <> 0 Goto ERROR


	--End

	fetch next from cur_id into @IdProgramacionActividad, @FechaDia
	End
		
	close cur_id
	deallocate cur_id

	--commit tran
	--return

--ERROR:
--	rollback tran
END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadRegistroUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadRegistroUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadRegistroUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadRegistroUpd]
    @Id int output,
	@Ids varchar(1000) = null,
	@Fechas varchar(1000) = null,
	@IdEstado int,
	@Responsables varchar(1000),
	@Auxiliares varchar(1000),
	@FechaEjecucion date,
    @IdUsuario int,
	@XMLProd varchar(MAx) = null,
	@XMLHerr varchar(MAx) = null,
	@XMLEx varchar(MAx) = null,
	@XMLTod varchar(MAx) = null
AS
BEGIN
	
	declare @FechaDia date, @IdProgramacionActividad int, @XMLProducto xml = @XMLProd, @XMLHerramienta xml = @XMLHerr, @GrupoProd int, @GrupoEx int,@GrupoHerr int, @IdMotivo int = 2, @XMLExterno xml = @xmlex,
			@XMLTodos xml = @xmlTod

	Create table #Tmp(Id int);

	Insert into #Tmp
	Select * from dbo.Split(@Ids, '|');


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@Fechas, '|');

	create table #Prod(
		Id int,
		IdBodega int,
		Valor decimal(18,2),
		Merma decimal(18,2),
		FechaVcto date
	)
	
	IF len(Isnull(@XMLProd ,'')) > 0
		Insert into #Prod
		SELECT
			T.split.value('./@IdProd', 'int') AS IdPRod,
			T.split.value('./@IdBodega', 'int') AS IdBodega,
			T.split.value('./@Valor', 'decimal(18,2)') AS Valor,
			T.split.value('./@Merma', 'decimal(18,2)') AS Merma,
			T.split.value('./@FechaVcto', 'date') AS FechaVcto
		FROM @XMLProducto.nodes('/v') T(split)
		
	create table #Todos(
		Id int,
		IdBodega int,
		Valor decimal(18,2),
		FechaVcto date
	)
	
	IF len(Isnull(@XMLTod ,'')) > 0
		Insert into #Todos
		SELECT
			T.split.value('./@IdProd', 'int') AS IdPRod,
			T.split.value('./@IdBodega', 'int') AS IdBodega,
			T.split.value('./@Valor', 'decimal(18,2)') AS Valor,
			T.split.value('./@FechaVcto', 'date') AS FechaVcto
		FROM @XMLTodos.nodes('/v') T(split)
		
	create table #Ex(
		Id int,
		Valor decimal(18,2)
	)
		
	IF len(Isnull(@XMLex ,'')) > 0
		Insert into #Ex
		SELECT
			T.split.value('./@IdProd', 'int') AS IdPRod,
			T.split.value('./@Valor', 'decimal(18,2)') AS Valor
		FROM @XMLExterno.nodes('/v') T(split)
		
		
		 
	create table #Herr(
		Id int,
		IdBodega int,
		Valor decimal(18,2),
		Merma decimal(18,2)
	)
	
	IF len(Isnull(@XMLHerr ,'')) > 0
		Insert into #Herr
		SELECT
			T.split.value('./@IdHerr', 'int') AS IdHerr,
			T.split.value('./@IdBodega', 'int') AS IdBodega,
			T.split.value('./@Valor', 'decimal(18,2)') AS Valor,
			T.split.value('./@Merma', 'decimal(18,2)') AS Merma
		FROM @XMLHerramienta.nodes('/v') T(split)
		
	Create table #TmpProgActivFecha (IdProgramacionActividad int, FechaDia date);

	Insert into #TmpProgActivFecha (IdProgramacionActividad, FechaDia)
	SELECT	distinct
			#Tmp.Id,
			#Tmp2.Fecha
	FROM 
		#Tmp
		CROSS APPLY #Tmp2;	

	
	select @GrupoProd = Max(Grupo) from ProgramacionActividadProd
	set @GrupoProd = Isnull(@GrupoProd,0) + 1
	
	select @GrupoHerr = Max(Grupo) from ProgramacionActividadHerr
	set @GrupoHerr = Isnull(@GrupoHerr,0) + 1
	
	select @Grupoex = Max(Grupo) from ProgramacionActividadEx
	set @Grupoex = Isnull(@Grupoex,0) + 1

	Begin tran

		Declare cur_id cursor for Select distinct IdProgramacionActividad, FechaDia from #TmpProgActivFecha
		open cur_id

		fetch next from cur_id into @IdProgramacionActividad, @FechaDia
		
		while @@fetch_status = 0
		BEgin
		
			Update ProgramacionActividadRegistro with(rowlock) set
				FechaRealizado = @FechaEjecucion,
				IdEstado = @IdEstado,
				Responsables = @Responsables,
				Auxiliares = @Auxiliares,
				IdUsuario = @IdUsuario		
			where 
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia
			If @@ERROR <> 0 Goto ERROR

			Update ProgramacionActividadProd with(rowlock) set
				Cantidad = P.Valor,
				Grupo = @GrupoProd,
				Merma = P.Merma
			From
				ProgramacionActividadProd inner join			
				ProgramacionActividadRegistro on ProgramacionActividadProd.IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id inner join
				#Prod as P on ProgramacionActividadProd.IdProducto = P.Id
			where 
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia
			If @@ERROR <> 0 Goto ERROR
			
			Insert into ProgramacionActividadProd with(Rowlock) (IdProgramacionActividadRegistro, IdProducto, Cantidad, Grupo)
			Select 
				ProgramacionActividadRegistro.Id, T.Id, T.Valor, @Grupoex 
			from
				ProgramacionActividadRegistro inner join
				ProgramacionActividad on ProgramacionActividadRegistro.IdProgramacionActividad =  ProgramacionActividad.Id Cross join
				#Todos as T
			Where
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia
			If @@ERROR <> 0 Goto ERROR

			Update ProgramacionActividadHerr with(rowlock) set
				Cantidad = ProgramacionActividadHerr.Cantidad - P.Valor,
				Grupo = @GrupoHerr,
				Merma = P.Merma
			From
				ProgramacionActividadHerr inner join			
				ProgramacionActividadRegistro on ProgramacionActividadHerr.IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id inner join
				#Herr as P on ProgramacionActividadHerr.IdHerramienta = P.Id
			where 
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia
			If @@ERROR <> 0 Goto ERROR

			Insert into ProgramacionActividadEx with(Rowlock) (IdProgramacionActividadRegistro, IdProducto, Cantidad, Grupo)
			Select 
				ProgramacionActividadRegistro.Id, T.Id, T.Valor, @Grupoex 
			from
				ProgramacionActividadRegistro inner join
				ProgramacionActividad on ProgramacionActividadRegistro.IdProgramacionActividad =  ProgramacionActividad.Id Cross join
				#Ex as T
			Where
				IdProgramacionActividad = @IdProgramacionActividad
				and Fecha = @FechaDia
			If @@ERROR <> 0 Goto ERROR
			
		fetch next from cur_id into @IdProgramacionActividad, @FechaDia
		End
		
		Update Existencia with(Rowlock) set  
			Cantidad = Cantidad - P.Valor
		From
			Existencia inner join
			#Prod as P on Existencia.IdProducto = P.Id and Existencia.IdBodega = P.IdBodega and Isnull(Existencia.FechaVcto,'19000101') = Isnull(P.FechaVcto,'19000101')
		If @@ERROR <> 0 Goto ERROR
		
		Update Existencia with(Rowlock) set  
			Cantidad = Cantidad - P.Valor
		From
			Existencia inner join
			#Todos as P on Existencia.IdProducto = P.Id and Existencia.IdBodega = P.IdBodega and Isnull(Existencia.FechaVcto,'19000101') = Isnull(P.FechaVcto,'19000101')
		If @@ERROR <> 0 Goto ERROR
		
		Update Existencia with(Rowlock) set  
			Cantidad = Cantidad + P.Valor
		From
			Existencia inner join
			#Herr as P on Existencia.IdHerramienta= P.Id and Existencia.IdBodega = P.IdBodega
		If @@ERROR <> 0 Goto ERROR
		
		
		Insert into Merma with(Rowlock) (Fecha, Observacion, IdMotivo, IdProducto, IdUsuarioCrea, FechaCrea, IdBodega)
		Select 
			@FechaEjecucion, 'Merma al Finalizar la Actividad',  @IdMotivo, Id, @IdUsuario, GETDATE(), IdBodega
		from 
			#Prod
		Where
			VAlor > 0
		If @@ERROR <> 0 Goto ERROR
			
		Insert into Merma with(Rowlock) (Fecha, Observacion, IdMotivo, IdHerramienta, IdUsuarioCrea, FechaCrea, IdBodega)
		Select 
			@FechaEjecucion, 'Merma al Finalizar la Actividad',  @IdMotivo, Id, @IdUsuario, GETDATE(), IdBodega
		from 
			#Herr
		Where
			VAlor > 0
		If @@ERROR <> 0 Goto ERROR

		UPdate Existencia with(Rowlock) set
			Cantidad = Existencia.Cantidad - T.Merma
		From 
			Existencia Inner join
			#Prod as T on Existencia.IdProducto = T.Id and Existencia.IdBodega = T.IdBodega	and Isnull(Existencia.FechaVcto,'19000101') = Isnull(T.FechaVcto,'19000101')
		Where
			VAlor > 0
		If @@ERROR <> 0 Goto ERROR
			
		UPdate Existencia with(Rowlock) set
			Cantidad = Existencia.Cantidad - T.Merma
		From 
			Existencia Inner join
			#Herr as T on Existencia.IdHerramienta = T.Id and Existencia.IdBodega = T.IdBodega
		Where
			VAlor > 0
		If @@ERROR <> 0 Goto ERROR


		close cur_id
		deallocate cur_id

	commit tran
	return

ERROR:
	close cur_id
	deallocate cur_id
	rollback tran

	--declare @FechaDia date = @FechaTexto;

	--Update ProgramacionActividadRegistro with(rowlock) set
	--	FechaRealizado = @FechaEjecucion,
	--	IdEstado = @IdEstado,
	--	Responsables = @Responsables,
	--	Auxiliares = @Auxiliares,
	--	IdUsuario = @IdUsuario		
	--where 
	--	IdProgramacionActividad = @IdProgramacionActividad
	--	and Fecha = @FechaDia

END







GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-09-24
-- Llamado desde:   ProgramacionActividad
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null,
	@IdUsuario		int

AS
BEGIN

SET DATEFIRST 1;

Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),		
		Id int , 
		FechaDia date,
		Dia varchar(30),
		Actividad varchar(250),	
		Temporada varchar(250),	
		Ensayo varchar(250),
		Lugar varchar(250),
		dds varchar(50),
		Responsable varchar(80),
		Prioridad varchar(50),
		IdProgramacion int,
		IdPrioridad int,
		Sel bit,
		FechaDiaTexto varchar(20),
		IdReg int
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'ProgramacionActividad.IdPrioridad asc'
  
	Set @Sql = 'SELECT DISTINCT 
                         ProgramacionActividad.Id, ProgramacionActividadRegistro.Fecha AS FechaDia, DiaSemana.Dia, ProgramacionActividad.Actividad, Temporada.Nombre AS Temporada, Ensayo.Codigo AS Ensayo, Lugar.Nombre AS Lugar, 
                         ProgramacionActividad.dds, AccUsuario.nombre_empleado AS Responsable, ProgramacionPrioridad.Prioridad, Programacion.Id AS IdProgramacion, ProgramacionActividad.IdPrioridad, CAST(0 AS bit) AS Sel, CONVERT(varchar, 
                         ProgramacionActividadRegistro.Fecha, 112) AS FechaDiaTexto , ProgramacionActividadRegistro.Id as IdReg
FROM            ProgramacionActividad INNER JOIN
                         ProgramacionActividadRegistro ON ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad INNER JOIN
                         Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
                         DiaSemana ON DATEPART(dw, ProgramacionActividadRegistro.Fecha) = DiaSemana.Id INNER JOIN
                         ProgramacionEstado ON ProgramacionActividad.IdEstado = ProgramacionEstado.Id INNER JOIN
                         ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id INNER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
                         AccUsuario ON Programacion.IdResponsable = AccUsuario.Id
				Where 
						ProgramacionActividadRegistro.IdEstado = 0 --(Exists (Select 1 From ProgramacionActividadRegistro where ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and ProgramacionActividadRegistro.Fecha = DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde) and ProgramacionActividadRegistro.IdEstado = 0 ))
						'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' And '+@Filtro
	End
		
		Set @Sql = @Sql+' Order By '+@Orden
    
	print @Sql
	Insert Into #Tmp (Id, FechaDia, Dia, Actividad, Temporada, Ensayo, Lugar, dds, Responsable, Prioridad, IdProgramacion, IdPrioridad, Sel, FechaDiaTexto, IdReg)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, FechaDia, Dia, Actividad, Temporada, Ensayo, Lugar, dds, Responsable, Prioridad, IdProgramacion, IdPrioridad, Sel, FechaDiaTexto, IdReg
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END






GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionActividadSel_Id] 
	@Id int
AS
BEGIN

	SELECT        ProgramacionActividad.Id, ProgramacionActividad.IdProgramacion, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, ProgramacionActividad.FechaHasta, ProgramacionActividad.IdEstado, 
                         ProgramacionActividad.IdPrioridad, ProgramacionActividad.Dias, ProgramacionActividad.Tratamiento, Ensayo.CantTratamiento, Isnull(Doc.CantArchivos,0) as CantArchivos,
						 ProgramacionActividad.Observacion, Programacion.IdLugar
	FROM            ProgramacionActividad INNER JOIN
							 Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id LEFT OUTER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id left join
				(
				Select IdProgramacionActividad, count(Id) as CantArchivos from ProgramacionActividadDoc group by IdProgramacionActividad
			) as Doc On ProgramacionActividad.Id = Doc.IdProgramacionActividad
	WHERE        (ProgramacionActividad.Id = @Id)
	
	
	SELECT        Id, IdDia
	FROM            ProgramacionDia
	WHERE        (IdProgramacionActividad = @Id)


	Select 
		 Id, Archivo AS Nombre
	from 
		ProgramacionActividadDoc
	Where
		IdProgramacionActividad = @Id

END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadSel_Ids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vane 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadDocSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadDocSel_Grids%'
-- --------------------------------
Create PROCEDURE [dbo].[ProgramacionActividadSel_Ids]
	@IdProgramacionActividad int output,
	@IdsProgAct varchar(1000) = null,
	@FechaTexto varchar(1000) = null
AS
BEGIN
	Create table #Tmp(
			IdProgramacionActividad int
		)
	
	Insert into #Tmp
	Select * from dbo.Split(@IdsProgAct, '|') 


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@FechaTexto, '|');


	Create table #TmpProgActivDoc (IdProgramacionActividad int, FechaDia date);

	Insert into #TmpProgActivDoc (IdProgramacionActividad, FechaDia)
	SELECT	distinct
			#Tmp.IdProgramacionActividad,
			#Tmp2.Fecha
	FROM 
		#Tmp
		CROSS APPLY #Tmp2;	


    SELECT   distinct     ProgramacionActividad.Id, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia,
								DiaSemana.Dia, ProgramacionActividad.Actividad, Temporada.Nombre AS Temporada, 
								Ensayo.Codigo AS Ensayo, Lugar.Nombre AS Lugar, ProgramacionActividad.dds,
								AccUsuario.nombre_empleado AS Responsable, ProgramacionPrioridad.Prioridad, 
								Programacion.Id AS IdProgramacion, ProgramacionActividad.IdPrioridad,
								CAST(0 AS bit) AS Sel, Convert(varchar, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ), 112) as FechaDiaTexto								
				FROM            ProgramacionActividad INNER JOIN
								PRogramacion On ProgramacionACtividad.IdProgramacion = Programacion.Id Inner join 
								ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
								DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
								ProgramacionEstado ON ProgramacionActividad.IdEstado = ProgramacionEstado.Id INNER JOIN
								ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id INNER JOIN
								Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
								Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
								Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
								AccUsuario ON Programacion.IdResponsable = AccUsuario.Id inner join
								#TmpProgActivDoc T on ProgramacionActividad.Id = T.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = T.FechaDia
				Where 
						(Exists (Select 1 From ProgramacionActividadRegistro where ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and ProgramacionActividadRegistro.Fecha = DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde) and ProgramacionActividadRegistro.IdEstado = 0 ))
						
						 Order By ProgramacionActividad.IdPrioridad asc

END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionActividadUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-09-04
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionActividadUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionActividadUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionActividadUpd]
    @Id int,
    @IdProgramacion int,
    @Actividad varchar (250),
    @FechaDesde date,
    @FechaHasta date,
    @IdPrioridad int,
	@Dias varchar(100),
	@Tratamientos varchar(100) = null,
	@Observacion varchar(1500) = null,
	@Producto varchar(Max) = null,
	@Herramienta varchar(Max) = null,
	@ValorDosis decimal(18,2) = null,
	@IdUM int = null, 
	@IdUMValor int = null,
	@TextoDosis varchar(100) = null
AS
BEGIN

	Declare @DiasText varchar(100)  = ''

	begin tran
	
		Select 
			data as Dias into #Dias
		from dbo.Split(@Dias, '|')
		where data > 0
		
		Select 
			@DiasText =  @DiasText + DiaSemana.Dia + ' - '
		from
			#Dias as T inner join
			DiaSemana on T.Dias = DiaSemana.Id

		set @DiasText = left(@DiasText, len(@DiasText) - 2)

		update ProgramacionActividad with(rowlock) set
			IdProgramacion = @IdProgramacion,
			Actividad = @Actividad,
			FechaDesde = @FechaDesde,
			FechaHasta = @FechaHasta,
			IdPrioridad = @IdPrioridad,
			Dias = @DiasText,
			Tratamiento = @Tratamientos,
			Observacion = @Observacion,
			ValorDosis = @ValorDosis, 
			IdMedida = @IdUM, 
			IdMedidaValor = @IdUMValor, 
			TextoDosis = @TextoDosis
		where 
			Id = @Id

		if @@ERROR <> 0 Goto ERROR
		
		Delete from ProgramacionDia with(Rowlock)
		Where
			IdProgramacionActividad = @Id
		if @@ERROR <> 0 Goto ERROR
		
		Insert into ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
		Select 
			data, @Id
		from dbo.Split(@Dias, '|') 
		where data > 0
		if @@ERROR <> 0 Goto ERROR
		
		Drop table #Dias

		Delete from ProgramacionActividadRegistro
		Where ProgramacionActividadRegistro.IdProgramacionActividad = @Id
		
		EXEC ProgramacionRegistroActividad_Crear @Id, @Producto, @Herramienta
		 
	Commit tran

	return

ERROR:
	rollback tran
END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-08-31
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionDel]
    @Id int
AS
BEGIN

delete from Programacion with(rowlock)
where Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[ProgramacionDocSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionDocSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionDocSel_Id]
    @Id int
AS
BEGIN

SELECT        Id, Nombre, NombreArchivo
FROM            ProgramacionDoc
WHERE        (Id = @Id)

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionDocSel_IdDoc]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionDocSel_Id%'
-- --------------------------------
Create PROCEDURE [dbo].[ProgramacionDocSel_IdDoc]
    @Id int
AS
BEGIN

SELECT        Id, Nombre, NombreArchivo, Archivo
FROM            ProgramacionDoc
WHERE        (Id = @Id)

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionDocUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionDocUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionDocUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionDocUpd]
    @Id int,
    @IdProgramacion int,
    @Nombre varchar (150),
    @NombreArchivo varchar (150),
    @Archivo image
AS
BEGIN

update ProgramacionDoc with(rowlock) set
    IdProgramacion = @IdProgramacion,
    Nombre = @Nombre,
    NombreArchivo = @NombreArchivo,
    Archivo = @Archivo
where 
    Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[ProgramacionIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-08-31
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionIns]
    @Id int output,
	@IdTemporada int,
    @IdEnsayo int = null,
	@IdResponsable int = null,
    @IdLugar int,
    @IdUsuario int
AS
BEGIN

	set @Id = null
	
	Select @Id = Id from Programacion where IdTemporada = @IdTemporada and IdEnsayo = @IdEnsayo and IdLugar = @IdLugar and IdResponsable = @IdResponsable

	If @Id is null
	BEgin

		insert into Programacion with(rowlock) (
					IdTemporada, IdEnsayo,  IdLugar, IdResponsable,  IdUsuario, IdEstado)
			values (
				@IdTemporada, @IdEnsayo, @IdLugar, @IdResponsable, @IdUsuario, 1)

		set @Id = scope_identity()
	End
END




GO
/****** Object:  StoredProcedure [dbo].[ProgramacionMas_Ins]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionMas_Ins] 
	@IdTemporada int,
	@Lugar varchar(1000) = null,
	@Ensayos varchar(1000) = null,
	@FechaDesde date = null,
	@FechaHasta date = null,
	@Dias varchar(1000) = null,
	@Actividad varchar(Max),
	@IdPrioridad int,
	@Observacion varchar(Max) = null,
	@IdUsuario int,
	@DiasCosecha int = null,
	@Producto varchar(Max) = null,
	@Herramienta varchar(Max) = null,
	@ValorDosis decimal(18,2) = null,
	@IdUM int = null, 
	@IdUMValor int = null,
	@IdSuperficieObj int = null,
	@TextoDosis varchar(100) = null,
	@ValorTotalDosis decimal(18,2) = null,
	@ValorSuperficie decimal(18,2) = null
AS
BEGIN

	set Datefirst 1

	Declare @IdEnsayo int, @DiasText varchar(100)  = '', @IdProgramacion int, @IdResponsable int, @IdProgramacionIdActividad int, @IdLugar int, @FechaSiembra date

	Create TAble #Dias(
		Dias int
	)
	
	Create TAble #Ensayos(
		IdEnsayo int
	)

	begin tran

		if len(@Dias) > 0
		Begin
			Insert into #Dias
			Select 
				data as Dias 
			from dbo.Split(@Dias, '|')
			where data > 0
			
			Select 
				@DiasText =  @DiasText + DiaSemana.Dia + ' - '
			from
				#Dias as T inner join
				DiaSemana on T.Dias = DiaSemana.Id

			set @DiasText = left(@DiasText, len(@DiasText) - 2)


		End

		if len(isnull(@Ensayos,'')) > 0
		Begin
			Insert into #Ensayos
			Select 
				data as IdEnsayo
			from dbo.Split(@Ensayos, '|')
			where data > 0
		End
		
		Select 
			data as IdLugar into #Lugar
		from dbo.Split(@Lugar, '|')
		where data > 0

		Declare cur_lu cursor for Select IdLugar from #Lugar
		open cur_lu

		fetch next from cur_lu into @IdLugar

		
		while @@fetch_status = 0
		BEgin
		

			If (Select count(IdEnsayo) from #Ensayos) > 0
			BEgin

				Declare cur_ens cursor for select IdEnsayo from #Ensayos
				open cur_ens

				fetch next from cur_ens into @IdEnsayo

				while @@fetch_status = 0
				BEgin
		
						select @IdProgramacion = null, @IdProgramacionIdActividad = null

						Select @IdResponsable = IdResponsable from Ensayo where Id = @IdEnsayo

						Select @IdProgramacion = Id From Programacion where IdTemporada = @IdTemporada and IdLugar = @IdLugar and IdEnsayo = @IdEnsayo

						If @IdProgramacion is null
						Begin

							insert into Programacion with(rowlock) (
									IdTemporada, IdEnsayo,  IdLugar, IdResponsable,  IdUsuario, IdEstado)
							values (
								@IdTemporada, @IdEnsayo, @IdLugar, @IdResponsable,  @IdUsuario, 1)
							If @@Error <> 0 Goto ERROR

							Set @IdProgramacion = scope_identity()

						End
			
						If @DiasCosecha > 0
					BEgin

						Declare cur_fec cursor for Select FechaSiembra from EnsayoFechaSiembra where IdEnsayo = @IdEnsayo

						open cur_fec 

						fetch next from cur_fec into @FechaSiembra

						while @@fetch_status = 0
						BEgin 
						
							set @FechaSiembra = dateadd(day, @DiasCosecha, @FechaSiembra)

							set @FechaDesde = dateadd(day, (datepart(dw, @FechaSiembra) * -1) + 1, @FechaSiembra)
							set @FechaHasta = dateadd(day, (datepart(dw, @FechaSiembra) * -1) + 7, @FechaSiembra)

							Select @DiasText = Dia from DiaSemana where Id = datepart(dw, @FechaSiembra)

							insert into ProgramacionActividad with(rowlock) (
								IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, dds, ValorDosis, IdMedida, IdMedidaValor, TextoDosis, IdSuperficieObj, ValorTotalDosis, ValorSuperficieObj)
								values (
									@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @DiasCosecha, @ValorDosis, @IdUM, @IdUMValor, @TextoDosis, @IdSuperficieObj, @ValorTotalDosis, @ValorSuperficie)
							if @@ERROR <> 0 Goto ERROR_fec

							set @IdProgramacionIdActividad = scope_identity()
		
							Insert into ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
							Values (datepart(dw, @FechaSiembra), @IdProgramacionIdActividad)
							If @@Error <> 0 Goto ERROR_fec
							
							exec ProgramacionRegistroActividad_Crear @IdProgramacionIdActividad, @Producto, @Herramienta 
							If @@Error <> 0 Goto ERROR_fec


							fetch next from cur_fec into @FechaSiembra
						End

						close cur_fec
						deallocate cur_fec

					End
					Else
					Begin
					
						insert into ProgramacionActividad with(rowlock) (
									IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, ValorDosis, IdMedida, IdMedidaValor, TextoDosis, IdSuperficieObj, ValorTotalDosis, ValorSuperficieObj)
							values (
								@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @ValorDosis, @IdUM, @IdUMValor, @TextoDosis, @IdSuperficieObj, @ValorTotalDosis, @ValorSuperficie)
						if @@ERROR <> 0 Goto ERROR

						set @IdProgramacionIdActividad = scope_identity()
		
						Insert into ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
						Select 
							Dias, @IdProgramacionIdActividad
						from #Dias
						If @@Error <> 0 Goto ERROR
						
						exec ProgramacionRegistroActividad_Crear @IdProgramacionIdActividad, @Producto, @Herramienta
						If @@Error <> 0 Goto ERROR

					End

					fetch next from cur_ens into @IdEnsayo
				End
								
				close cur_ens
				deallocate cur_ens
			
			End
			Else 
			Begin

				select @IdProgramacion = null, @IdProgramacionIdActividad = null

				Select @IdResponsable = IdResponsable from Ensayo where Id = @IdEnsayo

				Select @IdProgramacion = Id From Programacion where IdTemporada = @IdTemporada and IdLugar = @IdLugar and IdEnsayo = @IdEnsayo

				If @IdProgramacion is null
				Begin

					insert into Programacion with(rowlock) (
							IdTemporada, IdLugar, IdResponsable,  IdUsuario, IdEstado)
					values (
						@IdTemporada, @IdLugar, @IdResponsable, @IdUsuario, 1)
					If @@Error <> 0 Goto ERROR_Lu

					Set @IdProgramacion = scope_identity()

					insert into ProgramacionActividad with(rowlock) (
							IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, dds, Observacion, ValorDosis, IdMedida, IdMedidaValor, TextoDosis, IdSuperficieObj, ValorTotalDosis, ValorSuperficieObj)
					values (
						@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @DiasCosecha, @Observacion, @ValorDosis, @IdUM, @IdUMValor, @TextoDosis, @IdSuperficieObj, @ValorTotalDosis, @ValorSuperficie)
					if @@ERROR <> 0 Goto ERROR_Lu

					set @IdProgramacionIdActividad = scope_identity()
		
					Insert into ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
					Select 
						Dias, @IdProgramacionIdActividad
					from #Dias
					If @@Error <> 0 Goto ERROR_Lu
					
					exec ProgramacionRegistroActividad_Crear @IdProgramacionIdActividad, @Producto, @Herramienta
					If @@Error <> 0 Goto ERROR_Lu


		
		close cur_lu
		deallocate cur_lu
	commit tran
	return

ERROR_fec:

	close cur_fec
	deallocate cur_fec
	
ERROR:

	close cur_ens
	deallocate cur_ens
	

				End

			End

			fetch next from cur_lu into @IdLugar
		End
ERROR_Lu:

	close cur_lu
	deallocate cur_lu

	rollback tran


END


GO
/****** Object:  StoredProcedure [dbo].[ProgramacionMas_Val]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionMas_Val] 
	@IdTemporada int,
	@Lugar varchar(1000) = null,
	@Ensayos varchar(1000) = null,
	@FechaDesde date = null,
	@FechaHasta date = null,
	@Dias varchar(1000) = null,
	@Actividad varchar(Max),
	@IdPrioridad int,
	@Observacion varchar(Max) = null,
	@IdUsuario int,
	@DiasCosecha int = null
AS
BEGIN

	set Datefirst 1

	Declare @IdEnsayo int, @DiasText varchar(100)  = '', @IdProgramacion int, @IdResponsable int, @IdProgramacionIdActividad int, @IdLugar int, @FechaSiembra date,
			@EnsayosSinDDS varchar(MAx) = ''

	Create TAble #Dias(
		Dias int
	)
	
	Create TAble #Ensayos(
		IdEnsayo int
	)

	Create Table #Programacion (
		Id	int identity(1,1),
		IdTemporada	int,
		IdEnsayo	int,
		IdLugar	int,
		IdResponsable	int,
		Observacion	varchar(1500)
	)

	Create Table #ProgramacionActividad (
		Id	int identity(1,1),
		IdProgramacion	int,
		Actividad	varchar(250),
		FechaDesde	date,
		FechaHasta	date,
		IdEstado	int,
		IdPrioridad	int,
		Dias	varchar(100),
		dds int
	)
	
	Create Table #ProgramacionDia (
		Id	int identity(1,1),
		IdDia	int,
		IdProgramacionActividad	int
	)

	begin tran

		if len(@Dias) > 0
		Begin
			Insert into #Dias
			Select 
				data as Dias 
			from dbo.Split(@Dias, '|')
			where data > 0
			
			Select 
				@DiasText =  @DiasText + DiaSemana.Dia + ' - '
			from
				#Dias as T inner join
				DiaSemana on T.Dias = DiaSemana.Id

			set @DiasText = left(@DiasText, len(@DiasText) - 2)


		End

		if len(isnull(@Ensayos,'')) > 0
		Begin
			Insert into #Ensayos
			Select 
				data as IdEnsayo
			from dbo.Split(@Ensayos, '|')
			where data > 0
		End
		
		Select 
			data as IdLugar into #Lugar
		from dbo.Split(@Lugar, '|')
		where data > 0

		Declare cur_lu cursor for Select IdLugar from #Lugar
		open cur_lu

		fetch next from cur_lu into @IdLugar

		
		while @@fetch_status = 0
		BEgin
		

			If (Select count(IdEnsayo) from #Ensayos) > 0
			BEgin

				Declare cur_ens cursor for select IdEnsayo from #Ensayos
				open cur_ens

				fetch next from cur_ens into @IdEnsayo

				while @@fetch_status = 0
				BEgin
		
					select @IdProgramacion = null, @IdProgramacionIdActividad = null

					Select @IdResponsable = IdResponsable from Ensayo where Id = @IdEnsayo

					Select @IdProgramacion = Id From #Programacion where IdTemporada = @IdTemporada and IdLugar = @IdLugar and Isnull(IdEnsayo,-1) = Isnull(@IdEnsayo,-1)

					If @IdProgramacion is null
					Begin

						insert into #Programacion with(rowlock) (
								IdTemporada, IdEnsayo,  IdLugar, IdResponsable,  Observacion)
						values (
							@IdTemporada, @IdEnsayo, @IdLugar, @IdResponsable, @Observacion)
						If @@Error <> 0 Goto ERROR

						Set @IdProgramacion = scope_identity()

					End
			
					If @DiasCosecha > 0
					BEgin

						Select 
							@EnsayosSinDDS = @EnsayosSinDDS + Ensayo.Codigo + ',' 
						from 
							#Ensayos as T Inner join
							Ensayo on T.IdEnsayo = Ensayo.Id Left Outer join
							EnsayoFechaSiembra on Ensayo.Id = EnsayoFechaSiembra.IdEnsayo
						Where
							EnsayoFechaSiembra.Id Is null

						IF Len(isnull(@EnsayosSinDDS,'')) > 2
						Begin
							raiserror('Los ensayos %s no tienen fecha de siembra', 16,1,@EnsayosSinDDS)
							Goto ERROR
						End	

						Declare cur_fec cursor for Select FechaSiembra from EnsayoFechaSiembra where IdEnsayo = @IdEnsayo

						open cur_fec 

						fetch next from cur_fec into @FechaSiembra

						while @@fetch_status = 0
						BEgin 
						
							set @FechaSiembra = dateadd(day, @DiasCosecha, @FechaSiembra)

							set @FechaDesde = dateadd(day, (datepart(dw, @FechaSiembra) * -1) + 1, @FechaSiembra)
							set @FechaHasta = dateadd(day, (datepart(dw, @FechaSiembra) * -1) + 7, @FechaSiembra)

							Select @DiasText = Dia from DiaSemana where Id = datepart(dw, @FechaSiembra)

							insert into #ProgramacionActividad with(rowlock) (
								IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, dds)
								values (
									@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @DiasCosecha)
							if @@ERROR <> 0 Goto ERROR

							set @IdProgramacionIdActividad = scope_identity()
		
							Insert into #ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
							Values (datepart(dw, @FechaSiembra), @IdProgramacionIdActividad)
							If @@Error <> 0 Goto ERROR
							

							fetch next from cur_fec into @FechaSiembra
						End

						close cur_fec
						deallocate cur_fec

						--Select @FechaDesde = DATEADD(day, @DiasCosecha, FechaCosecha) From Ensayo where Id = @IdEnsayo
						--set @FechaHasta = @FechaDesde

						--delete from #Dias

						--insert into #Dias
						--values (datepart(dw, @FechaDesde))

						--Select @DiasText = Dia from DiaSemana where Id = datepart(dw, @FechaDesde)
					End
					Else
					Begin
					
						insert into #ProgramacionActividad with(rowlock) (
									IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, dds)
							values (
								@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @DiasCosecha)
						if @@ERROR <> 0 Goto ERROR

						set @IdProgramacionIdActividad = scope_identity()
		
						Insert into #ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
						Select 
							Dias, @IdProgramacionIdActividad
						from #Dias
						If @@Error <> 0 Goto ERROR
						
					End
			
						
					fetch next from cur_ens into @IdEnsayo
				End
								
				close cur_ens
				deallocate cur_ens
			
			End
			Else 
			Begin

				select @IdProgramacion = null, @IdProgramacionIdActividad = null

				Select @IdResponsable = IdResponsable from Ensayo where Id = @IdEnsayo

				Select @IdProgramacion = Id From #Programacion where IdTemporada = @IdTemporada and IdLugar = @IdLugar and IdEnsayo is null

				If @IdProgramacion is null
				Begin

					insert into #Programacion with(rowlock) (
							IdTemporada, IdLugar, IdResponsable,  Observacion)
					values (
						@IdTemporada, @IdLugar, @IdResponsable, @Observacion)
					If @@Error <> 0 Goto ERROR_Lu

					Set @IdProgramacion = scope_identity()

					insert into #ProgramacionActividad with(rowlock) (
							IdProgramacion,  Actividad,  FechaDesde,  FechaHasta,  IdEstado,  IdPrioridad, Dias, dds)
					values (
						@IdProgramacion, @Actividad, @FechaDesde, @FechaHasta, 1, @IdPrioridad, @DiasText, @DiasCosecha)
					if @@ERROR <> 0 Goto ERROR_Lu

					set @IdProgramacionIdActividad = scope_identity()
		
					Insert into #ProgramacionDia with(Rowlock) (IdDia, IdProgramacionActividad)
					Select 
						Dias, @IdProgramacionIdActividad
					from #Dias
					If @@Error <> 0 Goto ERROR_Lu
				End

			End

			fetch next from cur_lu into @IdLugar
		End

		
		close cur_lu
		deallocate cur_lu


		SELECT      #ProgramacionActividad.Id,  Temporada.Nombre AS Temporada, Ensayo.Codigo AS Ensayo, Lugar.Codigo AS Lugar, AccUsuario.usu_usuario AS Responsable, #ProgramacionActividad.Actividad, #ProgramacionActividad.FechaDesde, 
                         #ProgramacionActividad.FechaHasta, ProgramacionPrioridad.Prioridad, #ProgramacionActividad.Dias, #ProgramacionActividad.dds
		FROM            #Programacion INNER JOIN
								 #ProgramacionActividad ON #Programacion.Id = #ProgramacionActividad.IdProgramacion INNER JOIN
								 Temporada ON #Programacion.IdTemporada = Temporada.Id INNER JOIN
								 Lugar ON #Programacion.IdLugar = Lugar.Id INNER JOIN
								 ProgramacionPrioridad ON #ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id LEFT OUTER JOIN
								 AccUsuario ON #Programacion.IdResponsable = AccUsuario.Id LEFT OUTER JOIN
								 Ensayo ON #Programacion.IdEnsayo = Ensayo.Id


	commit tran
	return

ERROR:

	close cur_ens
	deallocate cur_ens
	

ERROR_Lu:

	close cur_lu
	deallocate cur_lu

	rollback tran


END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionRegistroActividad_Crear]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionRegistroActividad_Crear]
	@Id int,
	@Producto varchar(Max) = null,
	@Herramienta varchar(Max) = null
AS
BEGIN

	DEclare @XMLHerr xml = @Herramienta
	
	Create Table #Prod(
		Id int
	)
	
	Create Table #Herr(
		Id int,
		Cantidad decimal(18,2)
	)

	if Len(ISNULL(@Producto,'')) > 0
	Begin
		Insert into #Prod
		Select * from dbo.Split(@Producto, '|') where data > 0
	End
	
	if Len(ISNULL(@Herramienta,'')) > 0
	Begin
		Insert into #Herr
		SELECT
			T.split.value('./@Id', 'int') AS IdPRod,
			T.split.value('./@Cantidad', 'decimal(18,2)') AS IdBodega
		FROM @XmlHerr.nodes('/v') T(split)
	End

	Declare @Fecha date, @IdReg int

	Begin tran

		Declare cur_ra cursor for SELECT      
			DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde )	
		FROM            Programacion INNER JOIN
								 ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
								 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
								 DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id left outer join
								 ProgramacionActividadRegistro on ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) = ProgramacionActividadRegistro.Fecha
						 
		Where
			ProgramacionActividad.Id = @Id

		open cur_ra

		fetch next from cur_ra into @Fecha

		while @@FETCH_STATUS = 0
		BEgin
	
			Insert into ProgramacionActividadRegistro with(Rowlock) (IdProgramacionActividad, Fecha, IdEstado, IdUsuario, FechaCrea)
			Values (@Id, @Fecha, 0,1,getdate())
			if @@ERROR <> 0 Goto ERROR
	
			set @IdReg = scope_identity()

			Insert into ProgramacionActividadProd with(Rowlock) (IdProgramacionActividadRegistro, IdProducto)
			Select @IdReg, Id from #Prod
			if @@ERROR <> 0 Goto ERROR
							
			Insert into ProgramacionActividadHerr with(Rowlock) (IdProgramacionActividadRegistro, IdHerramienta, Cantidad)
			Select @IdReg, Id, Cantidad from #Herr
			if @@ERROR <> 0 Goto ERROR
			
			Update Existencia With(Rowlock) set 
				Cantidad = Existencia.Cantidad - T.Cantidad
			FRom 
				Existencia inner join
				#Herr as T on Existencia.IdHerramienta = T.Id
			if @@ERROR <> 0 Goto ERROR

			fetch next from cur_ra into @Fecha
		End

	
		close cur_ra
		deallocate cur_ra
	Commit tran

	return

ERROR:
	close cur_ra
	deallocate cur_ra
	rollback tran

END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionRegistroActividadProdHerr_Sel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionRegistroActividadProdHerr_Sel] 
	@Ids varchar(Max)
AS
BEGIN

	create table #T (
		Id int
	)

	Declare @IdLugar int

	Declare @strLugar varchar(Max) = '
	Insert into #T
	SELECT   Distinct Programacion.IdLugar
	FROM            ProgramacionActividadRegistro INNER JOIN
							 ProgramacionActividad ON ProgramacionActividadRegistro.IdProgramacionActividad = ProgramacionActividad.Id INNER JOIN
							 Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id 
	WHERE        (ProgramacionActividadRegistro.Id in('+@Ids+'))

	'
	exec(@strLugar)

	Select @IdLugar = Id from #T

	declare @SQL varchar(Max) = '

	SELECT DISTINCT ProgramacionActividadProd.IdProducto, Bodega.Id AS IdBodega, Producto.Codigo, Producto.Descripcion, ProgramacionActividadProd.Cantidad, Bodega.Nombre,Existencia.Cantidad as Stock, Existencia.FechaVcto,
		Convert(varchar, Existencia.FechaVcto, 112) as FechaVctoTexto
	FROM            ProgramacionActividadProd INNER JOIN
							 Producto ON ProgramacionActividadProd.IdProducto = Producto.Id LEFT OUTER JOIN
							 Existencia ON Producto.Id = Existencia.IdProducto LEFT OUTER JOIN
							 Bodega ON Existencia.IdBodega = Bodega.Id 
	WHERE        (ProgramacionActividadProd.IdProgramacionActividadRegistro in('+@Ids+')) and Bodega.IdLugar = '+Cast(@IdLugar as varchar)+'

	SELECT DISTINCT Existencia.IdProducto, Bodega.Id AS IdBodega, Producto.Codigo, Producto.Descripcion, null as Cantidad, Bodega.Nombre,Existencia.Cantidad as Stock, Existencia.FechaVcto,
		Convert(varchar, Existencia.FechaVcto, 112) as FechaVctoTexto
	FROM            
							 Producto LEFT OUTER JOIN
							 Existencia ON Producto.Id = Existencia.IdProducto LEFT OUTER JOIN
							 Bodega ON Existencia.IdBodega = Bodega.Id 
	WHERE         Bodega.IdLugar = '+Cast(@IdLugar as varchar)+'

	SELECT      
		distinct  ProgramacionActividadHerr.IdHerramienta, Bodega.Id AS IdBodega, Herramientas.Codigo, Herramientas.Nombre, ProgramacionActividadHerr.Cantidad, Bodega.Nombre as Bodega, Existencia.Cantidad as Stock
	FROM            
		ProgramacionActividadHerr INNER JOIN
		Herramientas ON ProgramacionActividadHerr.IdHerramienta = Herramientas.Id LEFT OUTER JOIN
							 Existencia ON Herramientas.Id = Existencia.IdHerramienta LEFT OUTER JOIN
							 Bodega ON Existencia.IdBodega = Bodega.Id 
	WHERE        (ProgramacionActividadHerr.IdProgramacionActividadRegistro in('+@Ids+')) and Bodega.IdLugar = '+Cast(@IdLugar as varchar)+'
	'

	print @sql
	Exec(@SQL)

	Select Id, Codigo, Descripcion, null as Cantidad from Producto 

END


GO
/****** Object:  StoredProcedure [dbo].[ProgramacionSel_Excel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionSel_Excel] 
	@FechaDesde date,
	@FechaHasta date
AS
BEGIN

	SELECT DISTINCT 
                         Temporada.Nombre AS Temporada, Ensayo.Codigo AS Ensayo, ProgramacionActividad.Actividad, AccUsuario.usu_usuario AS nombre_empleado, Lugar.Codigo AS Lugar, ProgramacionPrioridad.Prioridad, 
                         ProgramacionActividad.Dias, ProgramacionActividad.Observacion, ProgramacionActividad.FechaDesde, ProgramacionActividad.FechaHasta, ProgramacionDia.IdDia, DiaSemana.Dia, ProgramacionPrioridad.Color, 
                         Usuarios.usu_usuario, AsignacionActividad.IdUsuario, dbo.ConcatenarProductosProgramados(ProgramacionActividadRegistro.Id) as Productos,
						 dbo.ConcatenarHerramientasProgramados(ProgramacionActividadRegistro.Id) as Herramientas
FROM            Programacion INNER JOIN
                         ProgramacionActividad ON Programacion.Id = ProgramacionActividad.IdProgramacion INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
                         ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id INNER JOIN
                         ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
                         DiaSemana ON ProgramacionDia.IdDia = DiaSemana.Id INNER JOIN
                         ProgramacionActividadRegistro ON ProgramacionActividad.Id = ProgramacionActividadRegistro.IdProgramacionActividad LEFT OUTER JOIN
                         AccUsuario ON Programacion.IdResponsable = AccUsuario.Id LEFT OUTER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id CROSS JOIN
                         AccUsuario AS Usuarios LEFT OUTER JOIN
                         AsignacionActividad ON ProgramacionActividad.Id = AsignacionActividad.IdProgramacionActividad AND Usuarios.Id = AsignacionActividad.IdUsuario
WHERE        (ProgramacionActividad.FechaDesde <= @FechaHasta) AND (ProgramacionActividad.FechaHasta >= @FechaDesde)
union all
Select null AS Temporada, null AS Ensayo, null as Actividad, null nombre_empleado, null AS Lugar, null Prioridad, null Dias, 
                         null Observacion, null FechaDesde, null FechaHasta, Id IdDia, Dia, null as Color, null as usu_usuario,
						 null as IdUsuario, '' as Productos, '' as Herramientas
From 
	DiaSemana

END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-08-31
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN


Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),
		Id int ,
		CodEnsayo varchar (80),
		CodEspecie varchar (80),
		CodLugar varchar (80),
		Responsable varchar (80),
		UsuarioCrea varchar (80),
		Temporada varchar(100)
	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'Programacion.Id desc'
  
	Set @Sql = 'SELECT        Programacion.Id, Ensayo.Codigo AS CodEnsayo, Especie.Nombre AS CodEspecie, Lugar.Codigo AS CodLugar, AccUsuario.nombre_empleado AS Responsable, AccUsuario_1.nombre_empleado AS UsuarioCrea, 
                         Temporada.Nombre AS Temporada
FROM            Ensayo LEFT OUTER JOIN
                         Especie ON Ensayo.IdEspecie = Especie.Id RIGHT OUTER JOIN
                         Programacion INNER JOIN
                         Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
                         AccUsuario AS AccUsuario_1 ON Programacion.IdUsuario = AccUsuario_1.Id INNER JOIN
                         Temporada ON Programacion.IdTemporada = Temporada.Id LEFT OUTER JOIN
                         AccUsuario ON Programacion.IdResponsable = AccUsuario.Id ON Ensayo.Id = Programacion.IdEnsayo'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		Set @Sql = @Sql+' Order By '+@Orden
    
	Insert Into #Tmp (Id, CodEnsayo, CodEspecie, CodLugar, Responsable, UsuarioCrea, Temporada)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, CodEnsayo, CodEspecie, CodLugar, Responsable, UsuarioCrea, Temporada
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END



GO
/****** Object:  StoredProcedure [dbo].[ProgramacionSel_Herramienta]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionSel_Herramienta] 
	@IdLugar int
AS
BEGIN
	
	SELECT        
		Herramientas.Id, CAST(0 AS bit) AS Sel,  Herramientas.Codigo, Herramientas.Nombre, HerramientaCategoria.Categoria, Ex.Cantidad, ex.Nombre as Bodega
	FROM            
		Herramientas INNER JOIN
		HerramientaCategoria ON Herramientas.IdCategoria = HerramientaCategoria.Id left Outer join
		(
			SELECT        
				Existencia.IdHerramienta, Bodega.Nombre, SUM(Existencia.Cantidad) AS Cantidad
			FROM            
				Existencia INNER JOIN
				Bodega ON Existencia.IdBodega = Bodega.Id
			Where
				Bodega.IdLugar = @IdLugar
			GROUP BY 
				Existencia.IdHerramienta, Bodega.Nombre 
		) as Ex on Herramientas.Id = Ex.IdHerramienta

END


GO
/****** Object:  StoredProcedure [dbo].[ProgramacionSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-08-31
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionSel_Id]
    @Id int
AS
BEGIN

	SELECT        Programacion.Id, Programacion.IdTemporada, Programacion.IdEnsayo, Programacion.IdLugar, Programacion.IdResponsable, Ensayo.CantTratamiento
	FROM            Programacion LEFT OUTER JOIN
							 Ensayo ON Programacion.IdEnsayo = Ensayo.Id 
	WHERE        (Programacion.Id = @Id)




	SELECT        
		ProgramacionActividad.Id, ProgramacionActividad.IdProgramacion, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
		ProgramacionActividad.FechaHasta, ProgramacionActividad.IdEstado, 
        ProgramacionActividad.IdPrioridad, ProgramacionActividad.Dias, ProgramacionPrioridad.Prioridad, ProgramacionActividad.Observacion
	FROM            ProgramacionActividad INNER JOIN
							 ProgramacionPrioridad ON ProgramacionActividad.IdPrioridad = ProgramacionPrioridad.Id 
	WHERE        (ProgramacionActividad.IdProgramacion = @Id)
           
END







GO
/****** Object:  StoredProcedure [dbo].[ProgramacionSel_Productos]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionSel_Productos] 
	@IdLugar int
AS
BEGIN
	
	SELECT        Producto.Id, CAST(0 AS bit) AS Sel, Producto.Codigo, Producto.Descripcion, UnidadMedida.Sigla, CategoriaProducto.Categoria, Ex.Cantidad
FROM            Producto INNER JOIN
                         UnidadMedida ON Producto.IdUnidadMedida = UnidadMedida.id INNER JOIN
                         CategoriaProducto ON Producto.IdCategoria = CategoriaProducto.Id Left Outer join
						 (
							SELECT        
								Existencia.IdProducto, SUM(Existencia.Cantidad) AS Cantidad
							FROM            
								Existencia INNER JOIN
								Bodega ON Existencia.IdBodega = Bodega.Id
							Where
								Bodega.IdLugar = @IdLugar
							GROUP BY 
								Existencia.IdProducto
						 ) as Ex on Producto.Id = Ex.IdProducto

END


GO
/****** Object:  StoredProcedure [dbo].[ProgramacionTomarUM]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProgramacionTomarUM]
	@IdUM int,
	@IdUMSuperficie int
AS
BEGIN
	

	Select 
		UnidadMedida.Factor, Base.Factor as FactorBase
	FRom 
		UnidadMedida inner join
		UnidadMedida as Base on UnidadMedida.IdUMBase = Base.id
	Where
		UnidadMedida.id = @IdUM

	Select 
		UnidadMedida.Factor 
	from 
		UnidadMedida 
	where 
		id = @IdUMSuperficie

END
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-08-31
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ProgramacionUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ProgramacionUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ProgramacionUpd]
    @Id int,
	@IdTemporada int,
    @IdEnsayo int = null,
	@IdResponsable int = null,
    @IdLugar int,
    @IdUsuarioMod int
AS
BEGIN

update Programacion with(rowlock) set
	IdTemporada = @IdTemporada,
    IdEnsayo = @IdEnsayo,
    IdLugar = @IdLugar,
	IdResponsable = @IdResponsable,
    IdUsuarioMod = @IdUsuarioMod,
    FechaMod = getdate()
where 
    Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[RecepcionCambiarEstado]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RecepcionCambiarEstado]
	@Id int,
	@IdEstado int,
	@IdUsuario int
AS
BEGIN

	Declare @IdProducto int, @Cantidad decimal(18,2), @IdBodega int, @IdExistencia int, @Numero int, @FechaNull date = '19000101', @FechaVcto date, @IdHerramienta int

	BEgin tran

	

		If @IdEstado = 2
		BEgin
			
			select @Numero = MAx(Numero) from Recepcion 

			Update Recepcion set 
				IdEstado = @IdEstado,
				IdUsuarioMod= @IdUsuario,
				FechaMod = GETDATE(),
				Numero = Isnull(@Numero,0) + 1
			Where
				Id = @Id
			If @@ERROR <> 0 Goto ERROR

			declare cur_prod cursor For Select IdProducto, Cantidad, IdBodega, FechaVcto, IdHerramienta from RecepcionDet inner join Recepcion on RecepcionDet.IdRecepcion = recepcion.Id  where IdRecepcion = @Id
			open cur_prod

			fetch next from cur_prod into @IdProducto, @Cantidad, @IdBodega, @FechaVcto, @IdHerramienta

			while @@FETCH_STATUS = 0
			Begin
				
				set @IdExistencia = null
				Select @IdExistencia = Id from Existencia where Isnull(IdProducto,0) = Isnull(@IdProducto,0) and IdBodega = @IdBodega and Isnull(FechaVcto, @FechaNull) = Isnull(@FechaVcto, @FechaNull) and ISNULL(IdHerramienta, 0) = ISNULL(@IdHerramienta, 0)

				IF @IdExistencia is null
				Begin
					insert into Existencia (IdProducto, IdBodega,Cantidad, FechaVcto, IdHerramienta)
					VAlues (@IdProducto, @IdBodega, @Cantidad, @FechaVcto, @IdHerramienta)
					If @@ERROR <> 0 Goto ERROR_Cur
				End
				Else
				Begin
					Update Existencia set 
						Cantidad = @Cantidad
					where
						Id = @IdExistencia
					If @@ERROR <> 0 Goto ERROR_Cur
				End

				fetch next from cur_prod into @IdProducto, @Cantidad, @IdBodega, @FechaVcto, @IdHerramienta
			End

			close cur_prod
			deallocate cur_prod

		End

	Commit tran
	return

ERROR_Cur:
close cur_prod
deallocate cur_prod

ERROR:
	rollback tran


END


GO
/****** Object:  StoredProcedure [dbo].[RecepcionDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   Recepcion
-- Observaciones:   
-- Llamada SQL:     exec RecepcionDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDel]
    @Id int
AS
BEGIN

delete from Recepcion with(rowlock)
where Id = @Id

END




GO
/****** Object:  StoredProcedure [dbo].[RecepcionDetDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   RecepcionDet
-- Observaciones:   
-- Llamada SQL:     exec RecepcionDetDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDetDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDetDel]
    @Id int
AS
BEGIN

delete from RecepcionDet with(rowlock)
where Id = @Id

END





GO
/****** Object:  StoredProcedure [dbo].[RecepcionDetIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   RecepcionDet
-- Observaciones:   
-- Llamada SQL:     exec RecepcionIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDetIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDetIns]
    @Id int output,
	@IdRecepcion int,
	@IdProducto int = null,
    @Cantidad decimal(18,2),
	@FechaVcto date = null,
	@IdHerramienta int = null
AS
BEGIN

insert into RecepcionDet with(rowlock) (
        IdRecepcion, IdProducto, Cantidad,FechaVcto, IdHerramienta )
    values (
        @IdRecepcion, @IdProducto, @Cantidad,@FechaVcto, @IdHerramienta)

set @Id = scope_identity()


END







GO
/****** Object:  StoredProcedure [dbo].[RecepcionDetSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   RecepcionDet
-- Observaciones:   
-- Llamada SQL:     exec RecepcionDetSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDetSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDetSel_Grids]
	@IdRecepcion int
AS
	
BEGIN

SELECT        
	RecepcionDet.Id, RecepcionDet.IdRecepcion, RecepcionDet.IdProducto,  Isnull(Producto.Descripcion, Herramientas.Nombre) AS Producto, RecepcionDet.Cantidad, UnidadMedida.Nombre, RecepcionDet.FechaVcto
			
FROM            Herramientas RIGHT OUTER JOIN
                         RecepcionDet ON Herramientas.Id = RecepcionDet.IdHerramienta LEFT OUTER JOIN
                         UnidadMedida INNER JOIN
                         Producto ON UnidadMedida.id = Producto.IdUnidadMedida ON RecepcionDet.IdProducto = Producto.Id
WHERE        (RecepcionDet.IdRecepcion = @IdRecepcion)
ORDER BY RecepcionDet.Id DESC
END













GO
/****** Object:  StoredProcedure [dbo].[RecepcionDetSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   RecepcionDet
-- Observaciones:   
-- Llamada SQL:     exec RecepcionDetSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDetSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDetSel_Id]
    @Id int
AS
BEGIN
SELECT        RecepcionDet.Id, RecepcionDet.IdRecepcion, RecepcionDet.IdProducto, RecepcionDet.Cantidad, Recepcion.IdEstado, RecepcionDet.FechaVcto, UnidadMedida.Nombre, RecepcionDet.IdHerramienta
FROM            UnidadMedida INNER JOIN
                         Producto ON UnidadMedida.id = Producto.IdUnidadMedida RIGHT OUTER JOIN
                         RecepcionDet INNER JOIN
                         Recepcion ON RecepcionDet.IdRecepcion = Recepcion.Id ON Producto.Id = RecepcionDet.IdProducto
WHERE        (RecepcionDet.Id = @Id)

END







GO
/****** Object:  StoredProcedure [dbo].[RecepcionDetUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   RecepcionDet
-- Observaciones:   
-- Llamada SQL:     exec RecepcionDetUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionDetUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionDetUpd]
    @Id int,
    @IdRecepcion int,
	@FechaVcto date = null,
	@IdProducto int = null,
	@Cantidad decimal(18,2),
	@IdHerramienta int = null
AS
BEGIN

update RecepcionDet with(rowlock) set
    IdProducto = @IdProducto,
	Cantidad = @Cantidad,
	FechaVcto = @FechaVcto,
	IdHerramienta = @IdHerramienta
where 
    Id = @Id	

END






GO
/****** Object:  StoredProcedure [dbo].[RecepcionIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   Recepcion
-- Observaciones:   
-- Llamada SQL:     exec RecepcionIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionIns]
    @Id int output,
    @Fecha date,
	@IdBodega int,
    @Observacion varchar (1500) = null,
    @IdUsuarioCrea int
AS
BEGIN

insert into Recepcion with(rowlock) (
         Fecha,  IdEstado,  IdBodega, Observacion,  IdUsuarioCrea)
    values (
        @Fecha, 1, @IdBodega, @Observacion, @IdUsuarioCrea)

set @Id = scope_identity()


END






GO
/****** Object:  StoredProcedure [dbo].[RecepcionSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vanessa 2020-12-15
-- Llamado desde:   Recepcion
-- Observaciones:   
-- Llamada SQL:     exec RecepcionSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionSel_Grids]
	@Pagina         int Output,
	@TamanoPagina   int,
	@TotalRegistros int Output,
	@Orden          varchar(600)  = Null,
	@Filtro         varchar(4000) = Null,
	@IdPosicionar   int           = Null

AS
BEGIN


Declare @Sql varchar(max),
      @Paginas int
     
	Create Table #Tmp
	(
		IdTabla int Identity(1, 1),
		Id int,
		Numero int,
		Fecha date,
		Estado varchar(30),
		Bodega varchar(50),
		Observacion varchar(1500),
		UsuarioCrea nvarchar(20),
		FechaCrea date,
		UsuarioMod	nvarchar(20),
		FechaMod date

	)
            
	If ISNULL(@Orden, '') = '' Set @Orden = 'Recepcion.Fecha desc'
  
	Set @Sql = 'SELECT Distinct Recepcion.Id, Recepcion.Numero, Recepcion.Fecha, RecepcionEstado.Estado, 
						Bodega.Nombre, Recepcion.Observacion,
						AccUsuarioCrea.usu_usuario, Recepcion.FechaCrea, AccUsuarioMod.usu_usuario, Recepcion.FechaMod		
				FROM Recepcion INNER JOIN
					 RecepcionEstado ON Recepcion.IdEstado = RecepcionEstado.Id INNER JOIN
					 Bodega ON Recepcion.IdBodega = Bodega.Id LEFT JOIN
					 AccUsuario AS AccUsuarioCrea ON Recepcion.IdUsuarioCrea = AccUsuarioCrea.Id LEFT JOIN
					 AccUsuario As AccUsuarioMod ON Recepcion.IdUsuarioMod = AccUsuarioMod.Id Left join
					 RecepcionDet on Recepcion.Id = RecepcionDet.IdRecepcion'
	 
	If ISNULL(@Filtro, '') <> ''
	Begin
		Set @Sql = @Sql+' Where '+@Filtro
	End
		Set @Sql = @Sql+' Order By '+@Orden
    
	Insert Into #Tmp (Id, Numero, Fecha, Estado, Bodega, Observacion, UsuarioCrea, FechaCrea, UsuarioMod, FechaMod)
	Exec (@Sql)

	Set @TotalRegistros = @@RowCount
	Set @Paginas = CEILING(@TotalRegistros / CAST(@TamanoPagina As decimal))
 
	If @Pagina > @Paginas - 1
		Set @Pagina = @Paginas - 1

	If @Pagina < 0
		Set @Pagina = 0

	If Not @IdPosicionar Is Null
	Begin
		Declare @IdTabla int
		Select
			@IdTabla = IdTabla
		From   
			#Tmp
		Where  
			Id = @IdPosicionar

		If Not @IdTabla Is Null
		Begin
			Set @Pagina = FLOOR((@IdTabla - 1) / CAST(@TamanoPagina As decimal))
		End
	End

	--Select a mostrar
	Select
		Id, Numero, Fecha, Estado, Bodega, Observacion, UsuarioCrea, FechaCrea, UsuarioMod, FechaMod
	From   #Tmp
	Where  IdTabla Between @TamanoPagina * @Pagina + 1 And @TamanoPagina * (@Pagina + 1)


END





GO
/****** Object:  StoredProcedure [dbo].[RecepcionSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   Recepcion
-- Observaciones:   
-- Llamada SQL:     exec RecepcionSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionSel_Id]
    @Id int
AS
BEGIN

	SELECT        Recepcion.Id, Recepcion.Numero, Recepcion.Fecha, Recepcion.IdEstado, Recepcion.IdBodega, Recepcion.Observacion, RecepcionEstado.Estado
	FROM            Recepcion INNER JOIN
							 RecepcionEstado ON Recepcion.IdEstado = RecepcionEstado.Id
	WHERE        (Recepcion.Id = @Id)

	SELECT        RecepcionDet.Id, Producto.Codigo, Isnull(Producto.Descripcion,Herramientas.Nombre) as Descripcion, RecepcionDet.Cantidad, UnidadMedida.Sigla, RecepcionDet.FechaVcto
	FROM            Herramientas RIGHT OUTER JOIN
							 RecepcionDet ON Herramientas.Id = RecepcionDet.IdHerramienta LEFT OUTER JOIN
							 UnidadMedida INNER JOIN
							 Producto ON UnidadMedida.id = Producto.IdUnidadMedida ON RecepcionDet.IdProducto = Producto.Id
	WHERE        (RecepcionDet.IdRecepcion = @Id)
END






GO
/****** Object:  StoredProcedure [dbo].[RecepcionUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-12-14
-- Llamado desde:   Recepcion
-- Observaciones:   
-- Llamada SQL:     exec RecepcionUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%RecepcionUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[RecepcionUpd]
    @Id int,
	@Numero int,
    @Fecha date,
	@IdBodega int = null,	
    @Observacion varchar (1500) = null,
    @IdUsuarioMod int = null
AS
BEGIN

update Recepcion with(rowlock) set
	Fecha = @Fecha,
	IdBodega = @IdBodega,
    Observacion = @Observacion,
    IdUsuarioMod = @IdUsuarioMod,
    FechaMod = GETDATE()
where 
    Id = @Id

END






GO
/****** Object:  StoredProcedure [dbo].[RegistroActividadDiaSel_Rpt]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RegistroActividadDiaSel_Rpt]
	@FechaDesde date,
	@FechaHasta date
AS
BEGIN

	SELECT        Temporada.Nombre AS Temporada, Especie.Nombre AS Especie, Ensayo.Codigo AS Ensayo, Lugar.Codigo AS Lugar, AccUsuario.nombre_empleado AS Ejecuta, ProgramacionActividad.Actividad, 
                         Case When ProgramacionActividadRegistro.Fecha < getdate() then 'Atrasada' else ProgramacionActividadRegEstado.Estado end as Estado, ProgramacionActividadRegistro.Fecha, ProgramacionActividadMotivo.Motivo, ProgramacionActividadRegistro.ObsMotivo
	FROM            ProgramacionActividadRegistro INNER JOIN
							 ProgramacionActividad ON ProgramacionActividadRegistro.IdProgramacionActividad = ProgramacionActividad.Id INNER JOIN
							 Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
							 Lugar ON Programacion.IdLugar = Lugar.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id INNER JOIN
							 AccUsuario ON ProgramacionActividadRegistro.IdUsuario = AccUsuario.Id INNER JOIN
							 ProgramacionActividadRegEstado ON ProgramacionActividadRegistro.IdEstado = ProgramacionActividadRegEstado.Id LEFT OUTER JOIN
							 ProgramacionActividadMotivo ON ProgramacionActividadRegistro.IdMotivo = ProgramacionActividadMotivo.Id LEFT OUTER JOIN
							 Especie INNER JOIN
							 Ensayo ON Especie.Id = Ensayo.IdEspecie ON Programacion.IdEnsayo = Ensayo.Id
	Where
		ProgramacionActividadRegistro.Fecha >= @FechaDesde and ProgramacionActividadRegistro.Fecha <= @FechaHasta
END
GO
/****** Object:  StoredProcedure [dbo].[RegistroActividadPeriodoVal]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RegistroActividadPeriodoVal]
	@IdPrograAct int,
	@Fecha date
AS
BEGIN


	SELECT        Temporada.Id, Temporada.FechaDesde, Temporada.FechaHasta
	FROM            ProgramacionActividad INNER JOIN
							 Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
							 Temporada ON Programacion.IdTemporada = Temporada.Id
	WHERE        (ProgramacionActividad.Id = @IdPrograAct) and (Temporada.FechaDesde > @Fecha or Temporada.FechaHasta < @Fecha)


END
GO
/****** Object:  StoredProcedure [dbo].[RegistroActividadSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[RegistroActividadSel_Id] 
	@Id int,
	@IdUsuario int,
	@FechaDesde datetime,
	@FechaHasta datetime

AS
BEGIN

	SELECT        ProgramacionActividad.IdProgramacion, ProgramacionActividad.Actividad, ProgramacionActividad.FechaDesde, 
				  ProgramacionActividad.FechaHasta, ProgramacionActividad.IdEstado, ProgramacionActividad.IdPrioridad, ProgramacionActividad.Dias
	FROM            ProgramacionActividad inner join
					Programacion On ProgramacionACtividad.IdProgramacion = Programacion.Id
	WHERE ProgramacionActividad.IdProgramacion= @Id
	AND Programacion.IdUsuario = @IdUsuario
	AND (ProgramacionActividad.FechaDesde<@FechaHasta) and (ProgramacionActividad.FechaHasta>=FechaDesde)

END

GO
/****** Object:  StoredProcedure [dbo].[TemporadaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Temporada
-- Observaciones:   
-- Llamada SQL:     exec TemporadaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TemporadaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TemporadaDel]
    @Id int
AS
BEGIN

delete from Temporada with(rowlock)
where Id = @Id

END











GO
/****** Object:  StoredProcedure [dbo].[TemporadaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Temporada
-- Observaciones:   
-- Llamada SQL:     exec TemporadaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TemporadaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TemporadaIns]
    @Id int output,    
	@Nombre varchar(100), 
	@FechaDesde datetime, 
	@FechaHasta datetime,
	@Activo bit, 
	@IdUsuario int
AS
BEGIN

insert into Temporada with(rowlock) (
         Nombre, FechaDesde, FechaHasta, Activo, IdUsuario, FechaCrea)
    values (
        @Nombre, @FechaDesde, @FechaHasta, @Activo, @IdUsuario, GETDATE())

set @Id = scope_identity()

END











GO
/****** Object:  StoredProcedure [dbo].[TemporadaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Temporada
-- Observaciones:   
-- Llamada SQL:     exec TemporadaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TemporadaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TemporadaSel_Grids]
AS
BEGIN

SELECT        Id, Nombre, CONVERT(VARCHAR(10), FechaDesde, 103) FechaDesde, CONVERT(VARCHAR(10), FechaHasta, 103) FechaHasta, Activo, IdUsuario, FechaCrea, IdUsuarioMod, FechaMod
FROM            Temporada
ORDER BY Id

END










GO
/****** Object:  StoredProcedure [dbo].[TemporadaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Temporada
-- Observaciones:   
-- Llamada SQL:     exec TemporadaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TemporadaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TemporadaSel_Id]
	@Id int output
AS
BEGIN

SELECT        Id, Nombre, FechaDesde, FechaHasta, Activo
FROM            Temporada
WHERE		  Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[TemporadaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Temporada
-- Observaciones:   
-- Llamada SQL:     exec TemporadaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TemporadaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TemporadaUpd]
    @Id int,
	@Nombre varchar(100), 
	@FechaDesde datetime,
	@FechaHasta datetime,
	@Activo bit, 
	@IdUsuarioMod int
AS
BEGIN

update Temporada with(rowlock) set
	Nombre = @Nombre,
	FechaDesde = @FechaDesde,
	FechaHasta = @FechaHasta,
	Activo = @Activo,
	IdUsuarioMod = @IdUsuarioMod,
	FechaMod = GETDATE()
where 
    Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[TratamientoDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Tratamiento
-- Observaciones:   
-- Llamada SQL:     exec TratamientoDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TratamientoDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TratamientoDel]
    @Id int
AS
BEGIN

delete from Tratamiento with(rowlock)
where Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[TratamientoIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Tratamiento
-- Observaciones:   
-- Llamada SQL:     exec TratamientoIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TratamientoIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TratamientoIns]
    @Id int output,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuario int
AS
BEGIN

insert into Tratamiento with(rowlock) (
         Codigo, Nombre, Activo, IdUsuario, FechaCrea)
    values (
        @Codigo, @Nombre, @Activo, @IdUsuario, GETDATE())

set @Id = scope_identity()

END










GO
/****** Object:  StoredProcedure [dbo].[TratamientoSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Tratamiento
-- Observaciones:   
-- Llamada SQL:     exec TratamientoSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TratamientoSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TratamientoSel_Grids]
AS
BEGIN

SELECT        Id, Codigo, Nombre, Activo, IdUsuario, FechaCrea, IdUsuarioMod, FechaMod
FROM            Tratamiento
ORDER BY CODIGO

END









GO
/****** Object:  StoredProcedure [dbo].[TratamientoSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Tratamiento
-- Observaciones:   
-- Llamada SQL:     exec TratamientoSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TratamientoSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TratamientoSel_Id]
	@Id int output
AS
BEGIN

SELECT        Id, Codigo, Nombre, Activo
FROM            Tratamiento
WHERE		  Id = @Id

END









GO
/****** Object:  StoredProcedure [dbo].[TratamientoUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Vane 2020-08-21
-- Llamado desde:   Tratamiento
-- Observaciones:   
-- Llamada SQL:     exec TratamientoUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%TratamientoUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[TratamientoUpd]
    @Id int,
    @Codigo varchar(30), 
	@Nombre varchar(100), 
	@Activo bit, 
	@IdUsuarioMod int
AS
BEGIN

update Tratamiento with(rowlock) set
    Codigo = @Codigo,
	Nombre = @Nombre,
	Activo = @Activo,
	IdUsuarioMod = @IdUsuarioMod,
	FechaMod = GETDATE()
where 
    Id = @Id

END










GO
/****** Object:  StoredProcedure [dbo].[UnidadMedidaDel]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2021-01-20
-- Llamado desde:   Receta
-- Observaciones:   
-- Llamada SQL:     exec UnidadMedidaDel <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UnidadMedidaDel%'
-- --------------------------------
CREATE PROCEDURE [dbo].[UnidadMedidaDel]
    @id int
AS
BEGIN

delete from UnidadMedida with(rowlock)
where id = @id

END







GO
/****** Object:  StoredProcedure [dbo].[UnidadMedidaIns]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2021-01-20
-- Llamado desde:   Receta
-- Observaciones:   
-- Llamada SQL:     exec UnidadMedidaIns <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UnidadMedidaIns%'
-- --------------------------------
CREATE PROCEDURE [dbo].[UnidadMedidaIns]
    @id int output,
    @Sigla varchar (50),
    @Nombre varchar (50),
    @Factor decimal (18,2) = null,
	@Base bit,
	@IdUMBase int = null
AS
BEGIN

insert into UnidadMedida with(rowlock) (
         Sigla,  Nombre,  Factor, base, IdUMBase)
    values (
        @Sigla, @Nombre, @Factor, @Base, @IdUMBase)

set @id = scope_identity()

END







GO
/****** Object:  StoredProcedure [dbo].[UnidadMedidaSel_Grids]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2021-01-20
-- Llamado desde:   Receta
-- Observaciones:   
-- Llamada SQL:     exec UnidadMedidaSel_Grids <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UnidadMedidaSel_Grids%'
-- --------------------------------
CREATE PROCEDURE [dbo].[UnidadMedidaSel_Grids]
AS
BEGIN

SELECT        id, Sigla, Nombre, Factor
FROM            UnidadMedida

END






GO
/****** Object:  StoredProcedure [dbo].[UnidadMedidaSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2021-01-20
-- Llamado desde:   Receta
-- Observaciones:   
-- Llamada SQL:     exec UnidadMedidaSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UnidadMedidaSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[UnidadMedidaSel_Id]
    @id int
AS
BEGIN

SELECT        id, Sigla, Nombre, Factor, Base, IdUMBase
FROM            UnidadMedida
WHERE        (id = @Id)

END







GO
/****** Object:  StoredProcedure [dbo].[UnidadMedidaUpd]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- --------------------------------
-- Creado:          Ariel 2021-01-20
-- Llamado desde:   Receta
-- Observaciones:   
-- Llamada SQL:     exec UnidadMedidaUpd <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%UnidadMedidaUpd%'
-- --------------------------------
CREATE PROCEDURE [dbo].[UnidadMedidaUpd]
    @id int,
    @Sigla varchar (50),
    @Nombre varchar (50),
    @Factor decimal (18,2) = null,
	@Base bit ,
	@IdUMBase int = null
AS
BEGIN

update UnidadMedida with(rowlock) set
    Sigla = @Sigla,
    Nombre = @Nombre,
    Factor = @Factor,
	Base = @Base,
	IdUMBase = @IdUMBase
where 
    id = @id

END







GO
/****** Object:  StoredProcedure [dbo].[ValidacionCampexSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- --------------------------------
-- Creado:          Vane 2020-08-23
-- Llamado desde:   ProgramacionActividad
-- Observaciones:   
-- Llamada SQL:     exec ValidacionCampexSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ValidacionCampexSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ValidacionCampexSel_Id]    
	@Ids varchar(1000) = null,
	@Fechas varchar (1000) = null
	
AS
BEGIN
	Create table #Tmp(Id int);

	Insert into #Tmp
	Select * from dbo.Split(@Ids, '|');


	Create table #Tmp2(Fecha date);

	Insert into #Tmp2
	Select * from dbo.Split(@Fechas, '|');


	Create table #TmpProgActivFecha (IdProgramacionActividad int, FechaDia date);


	Insert into #TmpProgActivFecha (IdProgramacionActividad, FechaDia) 
	SELECT	distinct
			#Tmp.Id,
			#Tmp2.Fecha
	FROM 
		#Tmp
		CROSS APPLY #Tmp2;	

	SELECT ProgramacionActividadRegistro.Fecha, ProgramacionActividad.Id, Programacion.IdLugar
	FROM ProgramacionActividadRegistro inner join
		 ProgramacionActividad on ProgramacionActividadRegistro.IdProgramacionActividad = ProgramacionActividad.Id inner join
		 Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
		 #TmpProgActivFecha AS TmpProgActivFecha on ProgramacionActividadRegistro.IdProgramacionActividad = TmpProgActivFecha.IdProgramacionActividad and ProgramacionActividadRegistro.Fecha = TmpProgActivFecha.FechaDia
	group by ProgramacionActividadRegistro.Fecha, Programacion.IdEnsayo, Programacion.IdLugar


END


GO
/****** Object:  StoredProcedure [dbo].[ValidacionRegistroDocSel_Id]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ValidacionRegistroDocSel_Id <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ValidacionRegistroDocSel_Id%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ValidacionRegistroDocSel_Id]
	@IdProgramacionActividad int,
	@FechaDia date
AS
BEGIN

DEclare @IdProgActReg int , @CantDocSubido int, @CantDocSolicitado int

Select @IdProgActReg = Id from ProgramacionActividadRegistro where IdProgramacionActividad = @IdProgramacionActividad and Fecha = @FechaDia

Select @CantDocSubido = count(Id) from ProgramacionActividadRegistroDoc where IdProgramacionActividadRegistro = @IdProgActReg

select @CantDocSolicitado = Count(Id) from ProgramacionActividadDoc where IdProgramacionActividad = @IdProgramacionActividad and Obligatorio = 1

SELECT     @CantDocSolicitado = @CantDocSolicitado +   COUNT(EnsayoDoc.Id) 
FROM            ProgramacionActividad INNER JOIN
                         Programacion ON ProgramacionActividad.IdProgramacion = Programacion.Id INNER JOIN
                         Ensayo ON Programacion.IdEnsayo = Ensayo.Id INNER JOIN
                         EnsayoDoc ON Ensayo.Id = EnsayoDoc.IdEnsayo
WHERE        (EnsayoDoc.Obligatorio = 1) and ProgramacionActividad.Id = @IdProgramacionActividad

Set @CantDocSolicitado = isnull(@CantDocSolicitado,0)

if @CantDocSubido <> @CantDocSolicitado
	select 1 where 1 <> 1
Else
	select 1 

--select Archivos.Id, Archivos.IdProgramacionActividad, Archivos.FechaDia
--	from
--	 (  select ProgramacionActividadDoc.Id, ProgramacionActividad.Id AS IdProgramacionActividad,
--				DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia
--		from ProgramacionActividad inner join
--		ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
--		 ProgramacionActividadDoc ON ProgramacionActividad.Id = ProgramacionActividadDoc.IdProgramacionActividad
--		 and ProgramacionActividadDoc.Obligatorio = 1
--		Union All 
--		select EnsayoDoc.Id, ProgramacionActividad.Id AS IdProgramacionActividad,
--		DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) as FechaDia				
--		 from Programacion inner join		 
--		 ProgramacionActividad on Programacion.Id = ProgramacionActividad.IdProgramacion inner join
--		 ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad INNER JOIN
--		 EnsayoDoc on Programacion.IdEnsayo = EnsayoDoc.IdEnsayo and EnsayoDoc.Obligatorio= 1
--	 ) Archivos 
--	where Archivos.IdProgramacionActividad = @IdProgramacionActividad
--	and Archivos.FechaDia = @FechaDia
--	and (Not Exists (Select 1 From ProgramacionActividadRegistroDoc INNER JOIN
--							ProgramacionActividadRegistro ON ProgramacionActividadRegistroDoc.IdProgramacionActividadRegistro = ProgramacionActividadRegistro.Id
--							AND ProgramacionActividadRegistroDoc.IdProgramacionActividad = ProgramacionActividadRegistro.IdProgramacionActividad
--							and ProgramacionActividadRegistro.IdEstado = 0
--				 Where Archivos.IdProgramacionActividad = ProgramacionActividadRegistroDoc.IdProgramacionActividad
--				  and ((Archivos.Id = ProgramacionActividadRegistroDoc.IdProgramacionActividadDoc) and (Archivos.Id = ProgramacionActividadRegistroDoc.IdEnsayoDoc))
--				  ))
END





GO
/****** Object:  StoredProcedure [dbo].[ValidarFechasProgramacionActividad]    Script Date: 06/05/2021 04:28:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------
-- Creado:          Ariel 2020-09-20
-- Llamado desde:   Programacion
-- Observaciones:   
-- Llamada SQL:     exec ValidarFechasProgramacionActividad <PARAMETROS_PA>
-- Buscar: select * from sys.sql_modules where definition like '%ValidarFechasProgramacionActividad%'
-- --------------------------------
CREATE PROCEDURE [dbo].[ValidarFechasProgramacionActividad]
	@Id int
AS
BEGIN
	
	Select ProgramacionActividad.Id, DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde) AS Fecha
	from ProgramacionActividad inner join
		ProgramacionDia ON ProgramacionActividad.Id = ProgramacionDia.IdProgramacionActividad 
	where ProgramacionActividad.Id = @Id
	and DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde ) < GETDATE()

END

GO
