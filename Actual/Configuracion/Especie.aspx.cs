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
  public partial class Especie : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdEspecie;

    #endregion

    #region Inicial  

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniEspecie", "mniConf");
      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
      } else {
        IdEspecie = (int)ViewState["IdEspecie"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdEspecie", IdEspecie);
    }


    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      CargarGrilla();
    }

    #endregion

    #region Actualizar  

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("EspecieIns", objParam)) {
        IdEspecie = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdEspecie
      };

      if (objApp.Ejecutar("EspecieDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdEspecie,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("EspecieUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Especie"))
        return "Ya existe el código de la especie";

      if (error.Mensaje.Contains("IX_Especie_1"))
        return "Ya existe el nombre de la especie";

      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Código es requerido.");

      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Nombre es requerido.");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      IdEspecie = 0;
      txtCodigo.Text = null;
      txtNombre.Text = null;
      chkActivo.Checked = true;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("EspecieSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgEspecie, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("EspecieSel_Id", new object[] { IdEspecie });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdEspecie = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtNombre.Text = dtr["Nombre"].ToString();
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

      if (IdEspecie == 0)
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

    #endregion

    #region Eventos de Grillas

    protected void dtgEspecie_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgEspecie.PageIndex = e.NewPageIndex;
      dtgEspecie.DataBind();
      CargarGrilla();
    }

    protected void dtgEspecie_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdEspecie = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgEspecie_DataBound(object sender, EventArgs e) {
      if (dtgEspecie.HeaderRow != null)
        dtgEspecie.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgEspecie_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion
    
  }
}