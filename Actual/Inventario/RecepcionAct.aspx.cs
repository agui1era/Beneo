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
using static WEB.General.ClaseGeneral;
using System.Web.Services;

namespace WEB {

  public partial class RecepcionAct : FrmBase {

    #region Declaraciones 

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    int intId = 0;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniRecepcionAct", "mniInventario");

      if (!IsPostBack) {
        IniciarParametros();

        object objParam = TraerParametro(typeof(RecepcionCons));

        if (objParam != null) {
          intId = Convert.ToInt32(objParam);
        }


        LlenarControles();
      } else {
        intId = Convert.ToInt32(ViewState["intId"]);        
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("intId", intId);
      
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      LlenarDdls();
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtFecha.Text,
        ddlBodega.SelectedValue,
        txtObservacion.Text, 
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("RecepcionIns", objParam)) {
        miMaster.MensajeInformacion(this);
        intId = Convert.ToInt32(objParam[0]);
        LlenarControles();
        btnIngresarDet.Enabled = true;
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    
    private void Eliminar() {
      object[] objParam = new object[] {
        intId,
      };

      if (objApp.Ejecutar("RecepcionDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        //CargarGrilla();
        //LlamarFormulario("RecepcionCons.aspx", -1);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        intId,
        txtFecha.Text,
        ddlBodega.SelectedValue,
        txtObservacion.Text,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("RecepcionUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        btnIngresarDet.Enabled = true;
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private bool CambiarEstado(ESTADO_RECEPCION objEstado) {
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        intId,
        (int)objEstado,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("RecepcionCambiarEstado", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        btnIngresarDet.Enabled = true;
        return true;
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
        return false;
      }
    }

    #endregion

    #region Interfaz     

    #region Ddls
    private void LlenarDdls() {
      LlenarddlBodega(false);
      //LlenarddlProducto(false);
    }

    
    private bool LlenarddlBodega(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheBodega");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Nombre");
        }

      ddlBodega.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlBodega.DataBind();

      return true;
    }
    
    #endregion

    private void LimpiarControles() {
      intId = -1;
      txtFecha.Text = "";
      txtEstado.Text = "Pendiente de Recepción";
      ddlBodega.SelectedIndex = 0;
      txtObservacion.Text = "";
      btnGuardar.Enabled = true;
      btnEliminar.Enabled = false;
      btnConfirmar.Enabled = false;
      //btnNuevo.Enabled = false;
    }

    private void LlenarControles() {
      DataSet dts = objApp.TraerDataset("RecepcionSel_Id", new object[] { intId });

      if (dts != null) {

        RefrescarGrilla(dtgProductos, dts.Tables[1].DefaultView, false);
        if (dts.Tables[0].Rows.Count == 0) {
          LimpiarControles();
          return;
        }

        DataRow dtr = dts.Tables[0].Rows[0];
        
        txtNumero.Text = dtr["Numero"].ToString();
        txtFecha.Text = dtr["Fecha"].ToString();
        txtEstado.Text = dtr["Estado"].ToString();
        ddlBodega.SelectedValue = dtr["IdBodega"].ToString();
        txtObservacion.Text = dtr["Observacion"].ToString();


        if (intId != 0) {
          btnIngresarDet.Enabled = true;
        }

        ESTADO_RECEPCION objEst = (ESTADO_RECEPCION)(int)dtr["IdEstado"];

        btnGuardar.Enabled = objEst == ESTADO_RECEPCION.PorRecibir;
        btnEliminar.Enabled = objEst == ESTADO_RECEPCION.PorRecibir;
        btnConfirmar.Enabled = objEst == ESTADO_RECEPCION.PorRecibir;
        btnIngresarDet.Enabled = objEst == ESTADO_RECEPCION.PorRecibir;
      }

    }

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();
      
      if (string.IsNullOrWhiteSpace(txtFecha.Text))
        stbError.AppendLine("Fecha es requerido.");
      
      if (string.IsNullOrWhiteSpace(ddlBodega.SelectedValue))
        stbError.AppendLine("Bodega es requerido.");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private bool ValidarEliminar() {

      DataSet dt = objApp.TraerDataset("RecepcionDetSel_Grids", new object[] { intId });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {

        return true;
      }

      return false;
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

      if (intId <= 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ConfirmacionEliminacion", "$(\"#ConfirmacionEliminacion\").modal(\"show\");", true);
      if (ValidarEliminar()) {
        miMaster.MensajeError(this, Global.ERROR, "No puede eliminar Ingreso. Este tiene Productos asociados.");
      } else {
        Eliminar();
      }
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      intId = 0;
      LlenarControles();
    }

    protected void btnIngresarDet_Click(object sender, EventArgs e) {
      LlamarFormulario("RecepcionDetAct.aspx", intId);
    }

    protected void btnConfirmar_Click(object sender, EventArgs e) {
      if (CambiarEstado(ESTADO_RECEPCION.Recibido))
        LlenarControles();
    }
    
    #endregion

    #region Eventos de Grillas


    protected void dtgProductos_RowCommand(object sender, GridViewCommandEventArgs e) {
      //Id_Producto = Convert.ToInt32(e.CommandArgument);
      //if (e.CommandName == "Modificar") {
      //  LlenarControles();
      //}
    }

    protected void dtgProductos_DataBound(object sender, EventArgs e) {
      if (dtgProductos.HeaderRow != null)
        dtgProductos.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgProductos_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}