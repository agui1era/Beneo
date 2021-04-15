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


namespace WEB {
  public partial class Temporada : FrmBase {


    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdTemporada;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniTemporada", "mniConf");
      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
      } else {
        IdTemporada = (int)ViewState["IdTemporada"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdTemporada", IdTemporada);
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      CargarGrilla();
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      DateTime dtDesde, dtHasta;
      
      string[] strSplit = txtFechaDesde.Text.Split('/');
      dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));
      strSplit = txtFechaHasta.Text.Split('/');
      dtHasta = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));

      object[] objParam = new object[] {
        0,
        txtNombre.Text,
        dtDesde,
        dtHasta,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("TemporadaIns", objParam)) {
        IdTemporada = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdTemporada
      };

      if (objApp.Ejecutar("TemporadaDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      DateTime dtDesde, dtHasta;

      string[] strSplit = txtFechaDesde.Text.Split('/');
      dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));
      strSplit = txtFechaHasta.Text.Split('/');
      dtHasta = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));

      object[] objParam = new object[] {
        IdTemporada,
        txtNombre.Text,
        dtDesde,
        dtHasta,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("TemporadaUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Temporada"))
        return "Ya existe la temporada";
      
      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz        


    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      DateTime dtDesde, dtHasta;


      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Nombre es requerido.");  
      
      if(string.IsNullOrWhiteSpace(txtFechaDesde.Text))
        stbError.AppendLine("Fecha desde es requerida");
      else if (!DateTime.TryParse(txtFechaDesde.Text, out dtDesde))
        stbError.AppendLine("Fecha desde no válida");


      if (string.IsNullOrWhiteSpace(txtFechaHasta.Text))
        stbError.AppendLine("Fecha hasta es requerida");
      else if (!DateTime.TryParse(txtFechaHasta.Text, out dtHasta))
        stbError.AppendLine("Fecha hasta no válida");

      if (!string.IsNullOrWhiteSpace(txtFechaDesde.Text) && !string.IsNullOrWhiteSpace(txtFechaHasta.Text)) {
        if (Convert.ToDateTime(txtFechaHasta.Text) < Convert.ToDateTime(txtFechaDesde.Text)) {
          stbError.AppendLine("Fecha hasta no puede ser menor a Fecha desde.");
        }
      }

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR,  stbError.ToString());
        return false;
      }
      return true;
    }


    private void LimpiarControles() {
      IdTemporada = 0;
      txtNombre.Text = null;
      txtFechaDesde.Text = null;
      txtFechaHasta.Text = null;
      chkActivo.Checked = true;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("TemporadaSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgTemporada, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("TemporadaSel_Id", new object[] { IdTemporada.ToString() });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdTemporada = (int)dtr["Id"];
        txtNombre.Text = dtr["Nombre"].ToString();
        txtFechaDesde.Text = ((DateTime)dtr["FechaDesde"]).ToString("dd/MM/yyyy");
        txtFechaHasta.Text = ((DateTime)dtr["FechaHasta"]).ToString("dd/MM/yyyy");
        chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
      }
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

      if (IdTemporada == 0)
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

    protected void dtgTemporada_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgTemporada.PageIndex = e.NewPageIndex;
      dtgTemporada.DataBind();
      CargarGrilla();
    }

    protected void dtgTemporada_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdTemporada = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }


    #endregion

    #region Eventos de Grillas

    protected void dtgTemporada_DataBound(object sender, EventArgs e) {
      if (dtgTemporada.HeaderRow != null)
        dtgTemporada.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgTemporada_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}