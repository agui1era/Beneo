using ITD.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;

namespace WEB {
  public partial class Forma : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    DataSet dtAtrasados = null;

    enum MODAL_PRODUCTO {
      PorAcabar,
      PorVencer,
      Vencidos
    }

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      if (!IsPostBack) {
        //LlenarDashbard();
        LlenarDashActividad();
        LlenarDashResumen();
      } else {
        dtAtrasados = (DataSet)ViewState["Atrasados"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      LlenarCalendario();
    }

    private void LlenarCalendario() {
      DataSet dts = objApp.TraerDataset("DashboardSelCalendario", new object[] { objApp.InfoUsr.IdUsuario });
      StringBuilder stb = new StringBuilder();

      stb.AppendLine("events: [");
      foreach (DataRow item in dts.Tables[0].Rows) {
        stb.AppendLine("{");
        stb.AppendFormat("title: '{0} - {1} - {2}',", item["CodEns"], item["CodLugar"], item["Actividad"]).AppendLine();
        DateTime dt = (DateTime)item["FechaDia"];
        DateTime dtHasta = (DateTime)item["FechaDia"];
        stb.AppendFormat("start: new Date({0}, {1}, {2}),", dt.Year, dt.Month - 1, dt.Day).AppendLine();
        //stb.AppendFormat("end: new Date({0}, {1}, {2}),", dtHasta.Year, dtHasta.Month, dtHasta.Day).AppendLine();
        stb.AppendLine("allDay: false,");

        string strColor = "#00c0ef";
        string strForeColor = "#FFFFFF";

        if ((int)item["IdEstado"] == 0 && dt.Date < DateTime.Now.Date)
          strColor = "#DC3545";
        else if ((int)item["IdEstado"] == 1)
          strColor = "#07FC1A";
        else if ((int)item["IdEstado"] == 2) {
          strColor = "#FFC107";
          strForeColor = "#000000";
        }

        //if((DateTime)item["FechaDia"])

        stb.AppendLine("backgroundColor: '" + strColor + "',");
        stb.AppendLine("borderColor: '#00c0ef',");
        stb.AppendLine("foreColor: '" + strForeColor + "',");
        stb.AppendLine("url: '" + "../Programacion/IngresoActividad?Id=" + item["IdProgAct"].ToString() + "' ");
        stb.AppendLine("},");
      }

      stb.AppendLine("],");


      string strCalen = Properties.Resources.Calendario.Replace("@@REEMPLAZAR@@", stb.ToString());
      ClientScript.RegisterClientScriptBlock(this.GetType(), "Calen", strCalen);

    }

    private void LlenarDashActividad() {
      dtAtrasados = objApp.TraerDataset("DashboardNotificacionActividadPendiente", new object[] { objApp.InfoUsr.IdUsuario });

      if (dtAtrasados != null) {
        if (dtAtrasados.Tables[0].Rows.Count > 0) {
          ViewState.Add("Atrasados", dtAtrasados);
          RefrescarGrilla(dtgPrincipal, dtAtrasados.Tables[0].DefaultView, false);

          ScriptManager.RegisterStartupScript(Page, Page.GetType(), "dashAct", "$(\"#dashAct\").modal(\"show\");", true);
        }
      }
    }

    private void LlenarDashResumen() {
      DataSet dt = objApp.TraerDataset("DashboardSelResumen", null);

      if (dt != null) {
        if (dt.Tables[0].Rows.Count > 0) {

          DataRow dtr = dt.Tables[0].Rows[0];

          lblTotalActividad.Text = dtr["Total"].ToString();
          lblActRetrasados.Text = dtr["Atrasadas"].ToString();
          lblActTerminadas.Text = dtr["Terminadas"].ToString();
          lblActCanceladas.Text = dtr["Canceladas"].ToString();
          lblActividadesFuturas.Text = dtr["Futuras"].ToString();

          dtr = dt.Tables[1].Rows[0];

          lblProdAcabar.Text = dtr["PorAcabar"].ToString();

          dtr = dt.Tables[2].Rows[0];

          lblProductosVencer.Text = dtr["PorVencer"].ToString();
          lblProductosVencidos.Text = dtr["Vencidos"].ToString();

        }
      }
    }

    #endregion

    #region Actualizar        

    private void ModalTotalActividades() {

      object[] objParam = new object[] {
         objApp.InfoUsr.IdUsuario
      };

      DataTable dt = objApp.TraerTabla("DashboardNotificacionActividad", objParam);

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgTotalActividades, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-TotalActividades').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Info", script3);
      }

    }

    private void ModalActividadesAtrasadas() {

      object[] objParam = new object[] {
         objApp.InfoUsr.IdUsuario
      };

      DataTable dt = objApp.TraerTabla("DashboardNotificacionActividadAtrasadas", objParam);

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgActividadesAtrasadas, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-ActividadesAtrasadas').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      }

    }

    private void ModalActividadesTerminadas() {

      object[] objParam = new object[] {
         objApp.InfoUsr.IdUsuario
      };

      DataTable dt = objApp.TraerTabla("DashboardNotificacionActividadTerminada", objParam);

      if (dt != null) {
        RefrescarGrilla(dtgActividadesTerminadas, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-ActividadesTerminadas').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }

    }

    private void ModalActividadesCanceladas() {

      object[] objParam = new object[] {
         objApp.InfoUsr.IdUsuario
      };

      DataTable dt = objApp.TraerTabla("DashboardNotificacionActividadCancelada", objParam);

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgActividadesCanceladas, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-ActividadesCanceladas').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      }

    }

    private void ModalActividadesFuturas() {

      object[] objParam = new object[] {
         objApp.InfoUsr.IdUsuario
      };

      DataTable dt = objApp.TraerTabla("DashboardNotificacionActividadFutura", objParam);

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgActividadesFuturas, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-Futura').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      }

    }

    #endregion

    #region Interfaz        

    private void LLamarModalProducto(string strTitulo, MODAL_PRODUCTO objTipo) {
      object[] objParam;
      DataTable dt;
      switch (objTipo) {
        case MODAL_PRODUCTO.PorAcabar:
          objParam = new object[] {
             objApp.InfoUsr.IdUsuario
          };

          lblTituloProdModal.Text = strTitulo;

          dt = objApp.TraerTabla("DashboardNotificacionProducto", objParam);

          if (dt != null) {
            dtgProdVctoModal.Visible = false;
            dtgProdModal.Visible = true;
            RefrescarGrilla(dtgProdModal, dt.DefaultView, false);

            string script3 = "<script type=text/javascript> $(function () {$('#modal-Producto').modal('show')}); </script>";
            ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
          } else {
            miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          }
          break;
        case MODAL_PRODUCTO.PorVencer:
        case MODAL_PRODUCTO.Vencidos:
          objParam = new object[] {
             objApp.InfoUsr.IdUsuario,
             objTipo
          };

          lblTituloProdModal.Text = strTitulo;

          dt = objApp.TraerTabla("DashboardNotificacionProductoVcto", objParam);

          if (dt != null) {
            dtgProdModal.Visible = false;
            dtgProdVctoModal.Visible = true;
            RefrescarGrilla(dtgProdVctoModal, dt.DefaultView, false);
            string script3 = "<script type=text/javascript> $(function () {$('#modal-Producto').modal('show')}); </script>";
            ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
          } else {
            miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          }
          break;
        default:
          break;
      }



    }

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnTotalActividades_Click(object sender, EventArgs e) {
      ModalTotalActividades();
    }

    protected void btnActividadesAtrasadas_Click(object sender, EventArgs e) {
      ModalActividadesAtrasadas();
    }

    protected void btnActividadesTerminadas_Click(object sender, EventArgs e) {
      ModalActividadesTerminadas();
    }

    protected void btnActividadesCanceladas_Click(object sender, EventArgs e) {
      ModalActividadesCanceladas();
    }

    protected void btnModalGuardar_Click(object sender, EventArgs e) {
      DateTime dtMin = dtAtrasados.Tables[0].AsEnumerable().Min(s => (DateTime)s["FechaDia"]);
      DateTime dtMax = dtAtrasados.Tables[0].AsEnumerable().Max(s => (DateTime)s["FechaDia"]);
      LlamarFormulario("../Programacion/RegistroActividad", new object[] { dtMin, dtMax });
    }

    protected void lnkFuturas_Click(object sender, EventArgs e) {
      ModalActividadesFuturas();
    }

    protected void lnkProdAcabar_Click(object sender, EventArgs e) {
      LLamarModalProducto("Productos en Stock Bajo", MODAL_PRODUCTO.PorAcabar);
    }

    protected void lnkProductosVencer_Click(object sender, EventArgs e) {
      LLamarModalProducto("Productos por vencer", MODAL_PRODUCTO.PorVencer);
    }

    protected void lnkProductosVencidos_Click(object sender, EventArgs e) {
      LLamarModalProducto("Productos vencidos", MODAL_PRODUCTO.Vencidos);
    }
    #endregion

    #region Eventos de Grillas


    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgPrincipal_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgTotalActividades_DataBound(object sender, EventArgs e) {
      if (dtgTotalActividades.HeaderRow != null)
        dtgTotalActividades.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgTotalActividades_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgActividadesAtrasadas_DataBound(object sender, EventArgs e) {
      if (dtgActividadesAtrasadas.HeaderRow != null)
        dtgActividadesAtrasadas.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividadesAtrasadas_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgActividadesTerminadas_DataBound(object sender, EventArgs e) {
      if (dtgActividadesTerminadas.HeaderRow != null)
        dtgActividadesTerminadas.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividadesTerminadas_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgActividadesCanceladas_DataBound(object sender, EventArgs e) {
      if (dtgActividadesCanceladas.HeaderRow != null)
        dtgActividadesCanceladas.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividadesCanceladas_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgActividadesFuturas_DataBound(object sender, EventArgs e) {
      GridView grilla = (GridView)sender;
      if (grilla.HeaderRow != null)
        grilla.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividadesFuturas_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}