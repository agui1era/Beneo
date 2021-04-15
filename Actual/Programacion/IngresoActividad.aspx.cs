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

  public partial class IngresoActividad : FrmBase {

    #region Declaraciones 

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    int intId = 0;
    int ActId = 0;
    int? intIdLugar = null;
    int? intCantTratamientos = 0;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      if (!IsPostBack) {
        IniciarParametros();

        object objParam = TraerParametro(typeof(Programacion));

        if (objParam != null) {

          object[] arreglo = (object[])objParam;
          intId = Convert.ToInt32(arreglo[0]);
          ActId = Convert.ToInt32(arreglo[1]);
          intIdLugar = Convert.ToInt32(arreglo[2]);
        } else {
          objParam = TraerParametro(typeof(PrograActividadesCons));
          if (objParam != null) {

            object[] arreglo = (object[])objParam;
            intId = Convert.ToInt32(arreglo[0]);
            ActId = Convert.ToInt32(arreglo[1]);
          }
        }

        var strParam = Request.QueryString["Id"];

        if (!string.IsNullOrWhiteSpace(strParam))
          ActId = Convert.ToInt32(strParam);

        LlenarDatosIniciales();
        if (ActId <= 0) 
          LimpiarControlesActividad();          
        else
          LlenarControlesActividad();
        
      } else {
        intId = Convert.ToInt32(ViewState["intId"]);
        ActId = Convert.ToInt32(ViewState["ActId"]);
        intCantTratamientos = Convert.ToInt32(ViewState["intCantTratamientos"]);
      }
      
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("intId", intId);
      ViewState.Add("ActId", ActId);
      ViewState.Add("intCantTratamientos", intCantTratamientos);
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      LlenarDdls();
    }

    #endregion

    #region Actualizar        

    private void InsertarAct() {
      var tupla = Global.ObtenerFechas(txtRangoFecha);
      object[] objParam = new object[] {
        0,
        intId,
         ddlActividad.SelectedValue,
         tupla.Item1,
         tupla.Item2,
         ddlPrioridad.SelectedItem.Value,
         Global.ObtenerSeleccionados(lstDia),
         Global.ObtenerSeleccionados(lstTratamiento),
         txtObservaciones.Text,
        ObtenerMarcados(dtgProductos, 0),
        ObtenerXMLHerramienta(),
      };

      if (objApp.Ejecutar("ProgramacionActividadIns", objParam)) {
        ActId = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControlesActividad();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void ModificarAct() {
      var tupla = Global.ObtenerFechas(txtRangoFecha);
      object[] objParam = new object[] {
         ActId,
         intId,
         ddlActividad.SelectedValue,
         tupla.Item1,
         tupla.Item2,
         ddlPrioridad.SelectedItem.Value,
         Global.ObtenerSeleccionados(lstDia),
         Global.ObtenerSeleccionados(lstTratamiento),
         txtObservaciones.Text
      };

      if (objApp.Ejecutar("ProgramacionActividadUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControlesActividad();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void EliminarAct() {
      object[] objParam = new object[] {
        ActId
      };

         if (objApp.Ejecutar("ProgramacionActividadDel", objParam)) {
          miMaster.MensajeInformacion(this);
          LimpiarControlesActividad(); 
         } else {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
        }
     }
       
    private void InsertarDoc() {
      string strError = null;
      byte[] byt = FuncGen.FileToByte(Path.Combine(Server.MapPath("."), fluArchivo.FileName), ref strError);
      object[] objParam = new object[] {
        0,
        ActId,
        txtNombreArchivo.Text,
        fluArchivo.FileName,
        byt,
        chkObligatorio.Checked
      };

      if (objApp.Ejecutar("ProgramacionActividadDocIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControlesDoc();
        LlenarGrillaDoc();
        LlenarControlesActividad();
        File.Delete(Path.Combine(Server.MapPath("."), fluArchivo.FileName));

      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void EliminarDoc(int intIdDoc) {
      object[] objParam = new object[] {
        intIdDoc
      };

      if (objApp.Ejecutar("ProgramacionActividadDocDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarGrillaDoc();
        LlenarControlesActividad();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    #endregion

    #region Interfaz     

    #region Ddls

    private void LlenarDdls() {
      LlenarddlDia(false);
      LlenarddlActividad(false, "");
      LlenarddlPrioridad(false);
    }
           
   
    private bool LlenarddlDia(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheDia");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Dia");
      }

      dt.Columns.Add("Sel", typeof(bool));

      lstDia.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
      lstDia.DataBind();

      return true;
    }

    private bool LlenarddlPrioridad(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheProgramacionPrioridad");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Prioridad");
      }

      ddlPrioridad.DataSource = new DataView(dt, "Id > 0", "Id", DataViewRowState.OriginalRows);
      ddlPrioridad.DataBind();

      return true;
    }

    private bool LlenarddlActividad(bool bolMostrarMensaje, string strNuevo) {
      DataTable dt = objApp.TraerTabla("CacheActividad");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Nombre");
      }

      if (!string.IsNullOrWhiteSpace(strNuevo)) {
        DataRow dtr = dt.NewRow();
        dtr["Nombre"] = strNuevo;
        dt.Rows.Add(dtr);
        dt.AcceptChanges();
      }

      ddlActividad.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlActividad.DataBind();

      if (!string.IsNullOrWhiteSpace(strNuevo)) {
        ddlActividad.SelectedValue = strNuevo;
        txtNuevaActividad.Text = "";
      }

      return true;
    }
    #endregion
        
   
    private void LlenarControlesActividad() {
      DataSet dts = objApp.TraerDataset("ProgramacionActividadSel_Id", new object[] { ActId });    

      if (dts != null) {

        if (dts.Tables[0].Rows.Count == 0) {
          LimpiarControlesActividad();
          return;
        }

        DataRow dtr = dts.Tables[0].Rows[0];

        ddlActividad.SelectedValue = dtr["Actividad"].ToString();
        ddlPrioridad.SelectedValue = dtr["IdPrioridad"].ToString();
        intCantTratamientos = dtr["CantTratamiento"] as int?;
        txtObservaciones.Text = dtr["Observacion"].ToString();
        intIdLugar = dtr["IdLugar"] as int?;
        LlenarHerramientas();
        LlenarProductos();
        txtRangoFecha.Text = string.Format("{0} - {1}", ((DateTime)dtr["FechaDesde"]).ToString("dd/MM/yyyy"), ((DateTime)dtr["FechaHasta"]).ToString("dd/MM/yyyy")) ;
        lstDia.ClearSelection();

        string strTratamientos = dtr["Tratamiento"].ToString();

        if (!string.IsNullOrWhiteSpace(strTratamientos)) {
          strTratamientos.Split('|').ToList().ForEach(s => { if(!string.IsNullOrWhiteSpace(s))  lstTratamiento.Items.FindByValue(s).Selected = true; });
        }       

        dts.Tables[1].AsEnumerable().ToList().ForEach(s => lstDia.Items.FindByValue(s["IdDia"].ToString()).Selected = true );

        btnArchivo.Text = string.Format("{0} Archivo(s)", dtr["CantArchivos"]);

        foreach (DataRow item in dts.Tables[2].Rows) {
          HyperLink lnk = new HyperLink() { CssClass = "dropdown-item", ID = item["Id"].ToString(), Text = item["Nombre"].ToString() };
          lnk.NavigateUrl = "ProgramacionActividadDoc?IdDoc=" + lnk.ID;
          menuVer.Controls.Add(lnk);
        }
      }

      if (ActId <= 0) {
        btnArchivo.Enabled = false;
      } else {
        btnArchivo.Enabled = true;
      }
      btnGuardar.Enabled = true;
      btnEliminar.Enabled = true;
      btnNuevo.Enabled = true;

    }

    private void LimpiarControlesActividad() {
      ActId = -1;



      ddlActividad.SelectedIndex = -1;
      ddlPrioridad.SelectedIndex = -1;

      txtRangoFecha.Text = "";
      lstDia.ClearSelection();
      txtObservaciones.Text = "";
      btnEliminar.Enabled = false;
      btnArchivo.Enabled = false;
      btnNuevo.Enabled = false;
      LlenarProductos();
      LlenarHerramientas();
      btnArchivo.Text = "0 Archivo(s)";
    }

    private void LimpiarControlesDoc() {
      txtNombreArchivo.Text = "";
      chkObligatorio.Checked = false;
    }

    private void EnviarDoc(int intIdDoc) {

      DataTable dt = objApp.TraerTabla("ProgramacionActividadDocSel_IdDoc", new object[] { intIdDoc });

      if (dt != null) {

        DataRow dtr = dt.Rows[0];

        Response.Clear();
        Response.AddHeader("Content-Disposition", "attachment;filename=\"" + dtr["NombreArchivo"].ToString() + "\"");
        // edit this line to display ion browser and change the file name
        Response.BinaryWrite((byte[])dtr["Archivo"]);
        // gets our pdf as a byte array and then sends it to the buffer
        Response.Flush();
        Response.End();
      }

    }

    private void LlenarGrillaDoc() {

      DataTable dttTabla = objApp.TraerTabla("DocProgramacionActividadSel_Grids", new object[] { ActId });

      if (dttTabla != null) {
        RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

        var tupla = Global.ObtenerFechas(txtRangoFecha);
        if ((tupla.Item2 - tupla.Item1).TotalDays != 6)
          stbError.Append("El rango de fecha debe ser de 7 días <br>");
        else if (tupla.Item1.DayOfWeek != DayOfWeek.Monday)
          stbError.Append("El rango de fecha debe comenzar con el día lunes <br>");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: <br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private bool ValidarFechasProgramacionActividad(int ProgActId) {

      DataSet dt = objApp.TraerDataset("ValidarFechasProgramacionActividad", new object[] { ProgActId });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {

        return true;
      }

      return false;
    }

    private void LlenarProductos() {
      DataTable dt = objApp.TraerTabla("ProgramacionSel_Productos", new object[] { intIdLugar??0 });

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgProductos, dt.DefaultView, false);
      }

    }

    private void LlenarHerramientas() {
      DataTable dt = objApp.TraerTabla("ProgramacionSel_Herramienta", new object[] { intIdLugar ?? 0 });

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgHerramientas, dt.DefaultView, false);
      }

    }

    private void LlenarDatosIniciales() {
      DataTable dt = objApp.TraerTabla("ProgramacionSel_Id", new object[] { intId });

      if (dt != null) {
        DataRow dtr = dt.Rows[0];

        intCantTratamientos = (int)dtr["CantTratamiento"];

        for (int i = 1; i <= intCantTratamientos; i++) {
          lstTratamiento.Items.Add(i.ToString());
        }

      }

    }

    #endregion

    #region Acciones

    private string ObtenerMarcados(GridView dtg, int intCol) {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtg.Rows) {
        if (((CheckBox)item.Cells[intCol].Controls[0]).Checked)
          stb.AppendFormat("{0}|", dtg.DataKeys[item.RowIndex].Value);
      }

      if (stb.Length > 0)
        stb.Remove(stb.Length - 1, 1);

      return stb.ToString();
    }

    private string ObtenerXMLHerramienta() {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtgHerramientas.Rows) {
        if (((CheckBox)item.Cells[0].Controls[0]).Checked)
          stb.AppendFormat("<v Id=\"{0}\" Cantidad=\"{1}\" />", dtgHerramientas.DataKeys[item.RowIndex].Value, ((TextBox)item.Cells[dtgHerramientas.Columns.Count - 1].Controls[1]).Text.Replace(",", "."));
      }

      return stb.ToString();
    }

    #endregion


    #region Eventos de Barra

    #endregion


    #region Eventos de Controles

    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (Validar()) { 
        if (ActId <= 0)        
          InsertarAct();
        else
          ModificarAct();
      }
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      EliminarAct();
    }


    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControlesActividad();
    }    

    protected void btnNuevaActividad_Click(object sender, EventArgs e) {
      LlenarddlActividad(false, txtNuevaActividad.Text);
    }
       
    protected void btnArchivo_Click(object sender, EventArgs e) {

      LlenarGrillaDoc();      

      string script3 = "<script type=text/javascript> $(function () {$('#modal-archivo').modal('show')}); </script>";
      ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
    }

    protected void btnGuardarDoc_Click(object sender, EventArgs e) {
      InsertarDoc();
      LlenarControlesActividad();
    }

    protected void btnCerrarDoc_Click(object sender, EventArgs e) {
      LlenarControlesActividad();
    }

    protected void fluArchivo_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e) {
      File.WriteAllBytes(Path.Combine(Server.MapPath("."), fluArchivo.FileName), fluArchivo.FileBytes);

    }
    #endregion

    #region Eventos de Grillas

    protected void dtgActividades_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Modificar") {
        ActId = Convert.ToInt32(e.CommandArgument);
        btnEliminar.Enabled = true;
        LlenarControlesActividad();
      }
    }
        
    protected void dtgDocs_RowCommand(object sender, GridViewCommandEventArgs e) {
      int intIdDoc = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Eliminar") {
        EliminarDoc(intIdDoc);
      } else if (e.CommandName == "Visualizar") {
        EnviarDoc(intIdDoc);
      }
    }

    protected void dtgProductos_RowDataBound(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowIndex == -1) return;

      ((CheckBox)e.Row.Cells[0].Controls[0]).Enabled = true;

    }

    protected void dtgHerramientas_RowDataBound(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowIndex == -1) return;

      ((CheckBox)e.Row.Cells[0].Controls[0]).Enabled = true;

      DataRowView dtr = ((DataRowView)e.Row.DataItem);

      if (dtr.Row.IsNull("Cantidad") || (decimal)dtr["Cantidad"] == 0)
        e.Row.Cells[6].Controls.RemoveAt(1);

    }

    #endregion

    #region Persistencia 

    #endregion

    protected void lnkVolverProgramacion_Click(object sender, EventArgs e) {
      LlamarFormulario("Programacion.aspx", intId);
    }

    protected void btnCancelar_Click(object sender, EventArgs e) {
      LlamarFormulario("ProgramacionCons.aspx", null);
    }
  }
}