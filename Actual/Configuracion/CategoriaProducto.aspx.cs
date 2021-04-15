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
  public partial class CategoriaProducto : FrmBase {

    #region Declaraciones


    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdCategoria;

    #endregion

    #region Inicial 

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniCategoriaProducto", "mniConf");
      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
      } else {
        IdCategoria = (int)ViewState["Id"];
      }
    }


    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id", IdCategoria);
    }


    private void IniciarParametros() {
      CargarGrilla();
    }

    #endregion

    #region Actualizar

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtCategoria.Text
      };

      if (objApp.Ejecutar("CategoriaProductoIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdCategoria
      };

      if (objApp.Ejecutar("CategoriaProductoDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdCategoria,
        txtCodigo.Text,
        txtCategoria.Text
      };

      if (objApp.Ejecutar("CategoriaProductoUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }


    #endregion

    #region Interfaz


    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Código es requerido.");

      if (string.IsNullOrWhiteSpace(txtCategoria.Text))
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
      IdCategoria = 0;
      txtCodigo.Text = null;
      txtCategoria.Text = null;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("CategoriaProductoSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgCategoria, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
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

      if (IdCategoria == 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      Eliminar();
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControles();
    }

    #endregion

    #region Eventos de Grilla


    protected void dtgCategoria_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgCategoria.PageIndex = e.NewPageIndex;
      dtgCategoria.DataBind();
      CargarGrilla();
    }

    protected void dtgCategoria_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdCategoria = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {

        DataSet dt = objApp.TraerDataset("CategoriaProductoSel_Id", new object[] { IdCategoria.ToString() });

        if (dt != null && dt.Tables[0].Rows.Count > 0) {
          DataRow dtr = dt.Tables[0].Rows[0];

          IdCategoria = (int)dtr["Id"];
          txtCodigo.Text = dtr["Codigo"].ToString();
          txtCategoria.Text = dtr["Categoria"].ToString();
          btnNuevo.Enabled = true;
          btnEliminar.Enabled = true;
          btnGuardar.Enabled = true;
        }
      }
    }


    #endregion

    #region Persistencia
    #endregion


  }
}