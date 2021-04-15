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
  public partial class CategoriaHerramienta : FrmBase {

    #region Declaraciones
    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdCatHerramienta = 0;
    #endregion

    #region Inicial 
    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniCategoriaHerramienta", "mniConf");

      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
        CargarGrilla();
      } else {
        IdCatHerramienta = (int)ViewState["Id"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id", IdCatHerramienta);
    }
    #endregion

    #region Actualizar


    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtCatHerramienta.Text
      };

      if (objApp.Ejecutar("HerramientaCategoriaIns", objParam)) {
        IdCatHerramienta = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdCatHerramienta
      };

      if (objApp.Ejecutar("HerramientaCategoriaDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdCatHerramienta,
        txtCodigo.Text,
        txtCatHerramienta.Text
      };

      if (objApp.Ejecutar("HerramientaCategoriaUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();
      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Codigo es requerido.");
      if (string.IsNullOrWhiteSpace(txtCatHerramienta.Text))
        stbError.AppendLine("Categoria es requerido.");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      IdCatHerramienta = 0;
      txtCodigo = null;
      txtCatHerramienta = null;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("HerramientaCategoriaSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgCategoria, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }



    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("HerramientaCategoriaSel_Id", new object[] { IdCatHerramienta });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdCatHerramienta = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtCatHerramienta.Text = dtr["Categoria"].ToString();

        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
      }
    }

    
    #region Acciones
    #endregion

    #region Eventos de Barra
    #endregion

    #region Eventos de Controles


    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (IdCatHerramienta == 0)
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

    protected void dtgCategoria_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgCategoria.PageIndex = e.NewPageIndex;
      dtgCategoria.DataBind();
      CargarGrilla();
    }

    protected void dtgCategoria_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdCatHerramienta = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgCategoria_DataBound(object sender, EventArgs e) {
      if (dtgCategoria.HeaderRow != null)
        dtgCategoria.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgCategoria_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }


    #endregion


    #region Persistencia
    #endregion







  }
}