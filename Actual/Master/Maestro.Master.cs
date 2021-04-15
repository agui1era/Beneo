using ITD.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using System.Web.UI.HtmlControls;

namespace WEB {
  public partial class Maestro : System.Web.UI.MasterPage {


    #region Declaraciones 
    ClaseGeneral objApp;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      objApp = (ClaseGeneral)Session[FrmBase.LlaveGen];

      if(objApp.InfoUsr == null || objApp.InfoUsr.IdUsuario == null || (int)objApp.InfoUsr.IdUsuario == 0)
        Response.Redirect("../Login");

        lblUsuario.Text = objApp.InfoUsr.Nombre;

      //if (!IsPostBack) {
      //} else {
      //  lblUsuario.Text = "";
      //}

    }

    #endregion

    #region Actualizar        

    #endregion

    #region Interfaz        

    public void MarcarMenu(params string[] strOpciones) {

      foreach (string item in strOpciones) {

        HtmlAnchor link = (HtmlAnchor)FindControl(item);

        link.Attributes["class"] = link.Attributes["class"] + " active";


        if (link.Parent.ID.StartsWith("li"))
          ((HtmlGenericControl)link.Parent).Attributes["class"] = ((HtmlGenericControl)link.Parent).Attributes["class"] + " menu-open";
      }

    }

    #endregion

    #region Acciones


    public void MensajeInformacion(Page pagina) {
      
      string script3 = "<script type=text/javascript> $(function () { toastr.success('Información registrada con éxito') }); </script>";
      pagina.ClientScript.RegisterClientScriptBlock(GetType(), "Informacion", script3);
    }

    public void MensajeError(Page pagina, string titulo, string texto) {
      lblTituloError.Text = titulo;
      lblTextoError.Text = texto;

      string script3 = "<script type=text/javascript> $(function () {$('#modal-danger').modal('show')}); </script>";
      pagina.ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
    }

    public bool MensajeConfirmacion(Page pagina, string titulo, string texto) {
      lblTituloConf.Text = titulo;
      lblTextoConf.Text = texto;

      string script3 = "<script type=text/javascript> $(function () {$('#modal-warning').modal('show')}); </script>";
      pagina.ClientScript.RegisterClientScriptBlock(GetType(), "Confirmación", script3);

      return true;
    }
    
    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnDescargarExcel_Click(object sender, EventArgs e) {
      var tupla = Global.ObtenerFechas(txtRangoFechaDes);
      var objReporte = new Reporte("Reportes\\Programacion.rdlc");
      objReporte.Datos.Add(objApp.TraerTabla("ProgramacionSel_Excel", new object[] { tupla.Item1, tupla.Item2 }, 180));
      objReporte.Parametros.Add("Fechas", txtRangoFechaDes.Text);



      if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
        MensajeError(Page, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
        return;
      }

      objReporte.BajarReporte(Page, Reporte.Tipo.EXCEL, true, false);
      
    }

    protected void btnDescargarExcel2_Click(object sender, EventArgs e) {
      var tupla = Global.ObtenerFechas(txtRangoFechas);
      var objReporte = new Reporte("Reportes\\InformeEstadoActividades.rdlc");
      objReporte.Datos.Add(objApp.TraerTabla("EstadoActividadesSel_Excel", new object[] { tupla.Item1, tupla.Item2 }, 180));
      objReporte.Parametros.Add("Fechas", txtRangoFechas.Text);



      if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
        MensajeError(Page, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
        return;
      }

      objReporte.BajarReporte(Page, Reporte.Tipo.EXCEL, true, false);

    }

    protected void btnDescargarExcel3_Click(object sender, EventArgs e) {
      //var tupla = Global.ObtenerFechas(txtRangoFechas);
      var objReporte = new Reporte("Reportes\\InformeProductoActividad.rdlc");
      objReporte.Datos.Add(objApp.TraerTabla("ProductoActividadSel_Excel", null, 180));
      //objReporte.Parametros.Add("Fechas", txtRangoFechas.Text);



      if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
        MensajeError(Page, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
        return;
      }

      objReporte.BajarReporte(Page, Reporte.Tipo.EXCEL, true, false);

    }

    protected void btnDescargarDiaRep_Click(object sender, EventArgs e) {
      var tupla = Global.ObtenerFechas(txtRangoFechaAvance);
      var objReporte = new Reporte("Reportes\\InformeAvanceDiario.rdlc");
      objReporte.Datos.Add(objApp.TraerTabla("RegistroActividadDiaSel_Rpt", new object[] { tupla.Item1, tupla.Item2 }, 180));

      objReporte.Parametros.Add("Fecha", txtRangoFechaAvance.Text);

      if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
        MensajeError(Page, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
        return;
      }

      objReporte.BajarReporte(Page, Reporte.Tipo.EXCEL, true, false);
      
    }

    protected void lnkSalir_Click(object sender, EventArgs e) {
      objApp.InfoUsr.IdUsuario = null;
      Response.Redirect("../Login");
    }

    #endregion

    #region Eventos de Grillas

    #endregion

    #region Persistencia 

    #endregion

  }
}