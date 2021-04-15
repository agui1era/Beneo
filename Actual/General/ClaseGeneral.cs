using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using ITD.Web;
using System.Web.UI;
using System.IO;
using ITD.AccDatos;
using ITD.Funciones;
namespace WEB.General {

  public enum ESTADO_RECEPCION {
    PorRecibir = 1,
    Recibido = 2
  }

  public enum ESTADO_REGISTRO_ACTIVIDAD {
    Finalizado = 1,
    Cancelado = 2
  }

  public enum TIPO_USUARIO {
    Investigador = 1,
    Coordinador = 2,
    EncargadoCampex = 3,
    Auxiliar = 4
  }

  public class ClaseGeneral : DatosWeb {
    private AccMsSql datos;

    public enum ESTADOACTIVIDAD {
      Creada = 1
    }

    public enum RESULTADO_ACCESO : byte {
      Ok = 0,
      ErrorDesconocido = 1,
      NoExiste = 2,
      ClaveErronea = 3
    }

    public ClaseGeneral(AccMsSql datos)
            : base(datos) {
      InfoUsr = new InfoUsuario();
    }

    public new InfoUsuario InfoUsr {
      get { return (InfoUsuario)base.InfoUsr; }
      set { base.InfoUsr = value; }
    }

    public RESULTADO_ACCESO VerificarAccesoCliente(string strEmail, string strClave) {

      InfoUsr.IdUsuario = 0;

      object[] objParam = new object[] {
        0,
        strEmail,
        strClave,
        0
      };

      if (!Ejecutar("AccUsuarioClave", objParam)) {
        return RESULTADO_ACCESO.ErrorDesconocido;
      }


      if ((int)objParam[0] == 0) {
        return RESULTADO_ACCESO.NoExiste;
      }

      // Se verifica la clave
      bool bolValidarNormal = ITD.Funciones.LongEncript.Validar(strEmail.ToUpper(), strClave, Convert.ToUInt32(objParam[3]));

      if (!bolValidarNormal) {
        return RESULTADO_ACCESO.ClaveErronea;
      }

      var dtsTablas = TraerDataset("AccUsuarioExito", new object[] { objParam[0] });
      if (dtsTablas == null || dtsTablas.Tables[0].Rows.Count == 0)
        return RESULTADO_ACCESO.ErrorDesconocido;

      var dtrFila = dtsTablas.Tables[0].Rows[0];


      InfoUsr.IdUsuario = Convert.ToInt32(dtrFila["Id"]);
      InfoUsr.Nombre = dtrFila["nombre_empleado"].ToString();
      InfoUsr.TipoUsuario = (TIPO_USUARIO)(int)dtrFila["IdUsuarioTipo"];
      return RESULTADO_ACCESO.Ok;
    }
  }
  public class InfoUsuario : InfoUsuarioBase {
    public TIPO_USUARIO TipoUsuario { get; set; }
  }
}