using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using ITD.Web;
using ITD.Funciones;
using System.IO;
using ITD.Log;
using System.Globalization;

namespace WEB {
  public partial class EnsayoFecha : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    public int IdEnsayo { get; set; }
    int intIdFechaSiembra;
    
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      if (!IsPostBack) {
        IdEnsayo = Convert.ToInt32(TraerParametro(typeof(Ensayo)));

        LlenarControlesEnsayo();
        LlenarGrilla();
      } else {
        IdEnsayo = Convert.ToInt32(ViewState["IdEnsayo"]);
        intIdFechaSiembra = Convert.ToInt32(ViewState["intIdFechaSiembra"]);
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdEnsayo", IdEnsayo);
      ViewState.Add("intIdFechaSiembra", intIdFechaSiembra);
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      DateTime dtDesde;

      string[] strSplit = txtFechaSiembra.Text.Split('/');
      dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));

      object[] objParam = new object[] {
        0,
        IdEnsayo,
        dtDesde,
        Global.ObtenerSeleccionados(lstTratamientos).Replace("|", ",")
      };

      if (objApp.Ejecutar("EnsayoFechaSiembraIns", objParam)) {
        intIdFechaSiembra = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControlesFecha();
        LlenarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        intIdFechaSiembra
      };

      if (objApp.Ejecutar("EnsayoFechaSiembraDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        LlenarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      DateTime dtDesde;

      string[] strSplit = txtFechaSiembra.Text.Split('/');
      dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));

      object[] objParam = new object[] {
        intIdFechaSiembra,
        IdEnsayo,
        dtDesde,
        Global.ObtenerSeleccionados(lstTratamientos).Replace("|", ",")

      };

      if (objApp.Ejecutar("EnsayoFechaSiembraUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControlesFecha();
        LlenarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz        

    private void LlenarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("EnsayoFechaSiembraSel_Grids", new object[] { IdEnsayo });

      if (dttTabla != null) {
        RefrescarGrilla(dtgEnsayos, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarControlesEnsayo() {
      DataTable dt = objApp.TraerTabla("EnsayoSel_Id", new object[] { IdEnsayo });

      if (dt != null) {
        DataRow dtr = dt.Rows[0];

        lblTitulo.Text = string.Format("Fechas de siembra para el ensayo {0}", dtr["Codigo"]);


        DataTable dtTrat = new DataTable();
        dtTrat.Columns.Add("Id", typeof(int));
        dtTrat.Rows.Add(DBNull.Value);
        for (int i = 1; i <= Convert.ToInt32(dtr["CantTratamiento"]); i++) {
          dtTrat.Rows.Add(i);
        }

        lstTratamientos.DataSource = dtTrat.DefaultView;
        lstTratamientos.DataBind();
      }
    }

    private void LlenarControlesFecha() {
      DataTable dt = objApp.TraerTabla("EnsayoFechaSiembraSel_Id", new object[] { intIdFechaSiembra });

      if (dt != null) {
        DataRow dtr = dt.Rows[0];

        txtFechaSiembra.Text = ((DateTime)dtr["FechaSiembra"]).ToString("dd/MM/yyyy");

        lstTratamientos.ClearSelection();
        dtr["Tratamientos"].ToString().Split(',').ToList().ForEach(s => { if(!string.IsNullOrWhiteSpace(s)) lstTratamientos.Items.FindByValue(s).Selected = true; });

      }
    }

    private void LimpiarControles() {

      intIdFechaSiembra = 0;
      txtFechaSiembra.Text = "";
      lstTratamientos.ClearSelection();
    }

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      DateTime dtFechaSiembra;

      if (string.IsNullOrWhiteSpace(txtFechaSiembra.Text))
        stbError.AppendLine("Fecha de siembra es requerida");
      else if (!DateTime.TryParse(txtFechaSiembra.Text, out dtFechaSiembra))
        stbError.AppendLine("Fecha se siembra no válida");

     
      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (intIdFechaSiembra == 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ConfirmacionEliminacion", "$(\"#ConfirmacionEliminacion\").modal(\"show\");", true);
      Eliminar();
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControles();
    }

    protected void btnTodos_Click(object sender, EventArgs e) {
      for (int i = 1; i < lstTratamientos.Items.Count; i++) {
        lstTratamientos.Items[i].Selected = true;
      }
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgEnsayos_DataBound(object sender, EventArgs e) {
      if (dtgEnsayos.HeaderRow != null)
        dtgEnsayos.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgEnsayos_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgEnsayo_RowCommand(object sender, GridViewCommandEventArgs e) {
      intIdFechaSiembra = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControlesFecha();
      }
    }

    protected void dtgEnsayo_RowDataBound(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowIndex == -1) return;
      
      if (e.Row.RowType == DataControlRowType.DataRow) {
        DateTime dtFecha = DateTime.MinValue;

        DateTime.TryParseExact(e.Row.Cells[0].Text, "dd-MM-yyyy", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

        e.Row.Cells[1].Attributes.Add("data-order", dtFecha.Ticks.ToString());
      }

    }



    #endregion

    #region Persistencia 

    #endregion

  }
}