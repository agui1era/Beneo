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
  public partial class Ensayo : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdEnsayo;
    int IdEnsayoRel;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniEnsayo", "mniConf");

      if (!IsPostBack) {

        object objParam = TraerParametro(typeof(EnsayoClonar));
        if (objParam != null)
          IdEnsayo = Convert.ToInt32(objParam);

        string str = Request.QueryString["IdDoc"];

        if (!string.IsNullOrWhiteSpace(str)) {
          EnviarDoc(Convert.ToInt32(str));
        }

        IniciarParametros();
        LlenarDdls();
        if (IdEnsayo != 0) 
          LlenarControles();
        else
          LimpiarControles(); 
      } else {
        IdEnsayo = (int)ViewState["IdEnsayo"];
        IdEnsayoRel = (int)ViewState["IdEnsayoRel"];

      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdEnsayo", IdEnsayo);
      ViewState.Add("IdEnsayoRel", IdEnsayo);
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
        ddlTemporada.SelectedValue,
        ddlEspecie.SelectedValue,
        txtCodigo.Text,
        txtNombre.Text,
        ddlResponsable.SelectedValue,
        chkActivo.Checked,
        txtCantTratamiento.Text,
        txtCantRepeticion.Text,
        txtCantCosechas.Text,
        objApp.InfoUsr.IdUsuario,
        ddlLugar.SelectedValue
      };

      if (objApp.Ejecutar("EnsayoIns", objParam)) {
        IdEnsayo = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdEnsayo
      };

      if (objApp.Ejecutar("EnsayoDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {

      object[] objParam = new object[] {
        IdEnsayo,
        ddlTemporada.SelectedValue,
        ddlEspecie.SelectedValue,
        txtCodigo.Text,
        txtNombre.Text,
        ddlResponsable.SelectedValue,
        chkActivo.Checked,
        txtCantTratamiento.Text,
        txtCantRepeticion.Text,
        txtCantCosechas.Text,
        objApp.InfoUsr.IdUsuario,
         ddlLugar.SelectedValue,
      };

      if (objApp.Ejecutar("EnsayoUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    
    private void InsertarDoc() {
      string strError = null;
      byte[] byt = FuncGen.FileToByte(Path.Combine(Server.MapPath("."), fluArchivo.FileName), ref strError);
      object[] objParam = new object[] {
        0,
        IdEnsayo,
        txtNombreArchivo.Text,
        fluArchivo.FileName,
        byt,
        chkObligatorio.Checked
      };

      if (objApp.Ejecutar("EnsayoDocIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControlesDoc();
        LlenarGrillaDoc();
        LlenarControles();
        File.Delete(Path.Combine(Server.MapPath("."), fluArchivo.FileName));
        miMaster.MensajeInformacion(this);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void EliminarDoc(int intId) {
      object[] objParam = new object[] {
        intId
      };

      if (objApp.Ejecutar("EnsayoDocDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarGrillaDoc();
        LlenarControles();
        miMaster.MensajeInformacion(this);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Ensayo"))
        return "Ya existe el código para la temporada seleccionada";

      if (error.Mensaje.Contains("IX_Ensayo_1"))
        return "Ya existe el ensayo para la temporada seleccionada";

      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz        

    private void LimpiarControles() {
      txtCodigo.Text = null;
      txtNombre.Text = null;
      chkActivo.Checked = true;
      ddlTemporada.SelectedIndex = -1;
      ddlEspecie.SelectedIndex = -1;
      ddlResponsable.SelectedIndex = -1;
      txtCantTratamiento.Text = null;
      txtCantRepeticion.Text = null;
      txtCantCosechas.Text = null;
      btnArchivo.Text = "0 Archivo(s)";
      ddlLugar.SelectedIndex = -1;
      grpArchivos.Visible = false;
      grpFechas.Visible = false;
      btnFechaCosecha.Text = "0 Fechas";
      IdEnsayo = 0;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnClonar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("EnsayoSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgEnsayos, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarControles() {

      DataSet dts = objApp.TraerDataset("EnsayoSel_Id", new object[] { IdEnsayo.ToString() });

      if (dts != null && dts.Tables[0].Rows.Count > 0) {
        DataRow dtr = dts.Tables[0].Rows[0];

        IdEnsayo = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtNombre.Text = dtr["Nombre"].ToString();
        ddlTemporada.SelectedValue = dtr["IdTemporada"].ToString();

        grpArchivos.Visible = true;
        grpFechas.Visible = true;
        LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
        
        ddlLugar.SelectedValue = dtr["IdLugar"].ToString();
        ddlEspecie.SelectedValue = dtr["IdEspecie"].ToString();
        ddlResponsable.SelectedValue = dtr["IdResponsable"].ToString();
        chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
        txtCantTratamiento.Text = dtr["CantTratamiento"].ToString();
        txtCantRepeticion.Text = dtr["CantRepeticion"].ToString();
        txtCantCosechas.Text = dtr["CantCosechas"].ToString();
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
        btnClonar.Enabled = true;


        DataTable dt = new DataTable();
        dt.Columns.Add("Id", typeof(int));
        dt.Rows.Add(DBNull.Value);
        for (int i = 1; i < Convert.ToInt32(txtCantTratamiento.Text); i++) {
          dt.Rows.Add(i);
        }
        
        btnArchivo.Text = string.Format("{0} Archivo(s)",  dtr["CantArchivos"]);
        btnFechaCosecha.Text = string.Format("{0} Fecha(s)", dtr["CantFechasEnsayo"]);

        foreach (DataRow item in dts.Tables[1].Rows) {
          HyperLink lnk = new HyperLink() { CssClass = "dropdown-item", ID = item["Id"].ToString(), Text = item["Nombre"].ToString() };
          lnk.NavigateUrl = "Ensayo?IdDoc=" + lnk.ID;
          menuVer.Controls.Add(lnk);
        }

      }
    }
    
    private void LlenarDdls() {
      //LlenarddlEnsayo(false);
      LlenarddlTemporada(false);
      LlenarddlEspecie(false);
      LlenarddlResponsable(false);
      //LlenarddlPrioridad(false);
    }

    private bool LlenarddlTemporada(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheTemporada");

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

      ddlTemporada.DataSource = new DataView(dt, "Id > 0", "Nombre", DataViewRowState.OriginalRows);
      ddlTemporada.DataBind();

      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));

      return true;
    }

    private bool LlenarddlResponsable(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheResponsable");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("nombre_empleado");
          dt.Columns.Add("usu_usuario");
        }

      ddlResponsable.DataSource = new DataView(dt, "Id > 0", "usu_usuario", DataViewRowState.OriginalRows);
      ddlResponsable.DataBind();

      return true;
    }

    private bool LlenarddlEspecie(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheEspecie");

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

      ddlEspecie.DataSource = new DataView(dt, "Id > 0", "Nombre", DataViewRowState.OriginalRows);
      ddlEspecie.DataBind();

      return true;
    }

    private bool LlenarddlLugar(bool bolMostrarMensaje, int intIdTemporada) {
      DataTable dt = objApp.TraerTabla("CacheLugar");

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

      ddlLugar.DataSource = new DataView(dt, string.Format("IdTemporada={0}", intIdTemporada), "Nombre", DataViewRowState.OriginalRows);
      ddlLugar.DataBind();

      return true;
    }

    private void LlenarGrillaDoc() {

      DataTable dttTabla = objApp.TraerTabla("EnsayoDocSel_Grids", new object[] { IdEnsayo });

      if (dttTabla != null) {
        RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarGrillaFecha() {

      DataTable dttTabla = objApp.TraerTabla("EnsayoFechaSel_Grids", new object[] { IdEnsayo });

      if (dttTabla != null) {
        RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LimpiarControlesDoc() {
      txtNombreArchivo.Text = "";
      chkObligatorio.Checked = false;
    }

    private void EnviarDoc(int intIdDoc) {

      DataTable dt = objApp.TraerTabla("EnsayoDocSel_IdDoc", new object[] { intIdDoc });

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

    private bool ValidarEnsayoFechas() {

      DataSet dt = objApp.TraerDataset("EnsayoFechaSiembraSel_Grids", new object[] { IdEnsayo });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {

        return true;
      }

      return false;
    }

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();      

      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Código es requerido.");

      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Nombre es requerido.");

      if (string.IsNullOrWhiteSpace(txtCantTratamiento .Text))
        stbError.AppendLine("Cantidad de tratamiento es requerido.");

      if (string.IsNullOrWhiteSpace(txtCantRepeticion .Text))
        stbError.AppendLine("Cantidad de repetición es requerido.");

      if (string.IsNullOrWhiteSpace(txtCantCosechas.Text))
        stbError.AppendLine("Cantidad de cosechas es requerido.");      

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

    public byte[] ReadFully(Stream input) {
      byte[] result;
      using (var streamReader = new MemoryStream()) {
        input.CopyTo(streamReader);
        result = streamReader.ToArray();
      }

      return result;
    }

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (IdEnsayo == 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ConfirmacionEliminacion", "$(\"#ConfirmacionEliminacion\").modal(\"show\");", true);
      if (ValidarEnsayoFechas()) {
        miMaster.MensajeError(this, Global.ERROR, "No puede eliminar Ensayo. Este tiene fechas de siembra asociadas.");
      } else {
        Eliminar();
      }
    }

    public void btnClonar_Click(object sender, EventArgs e) {
      LlamarFormulario("EnsayoClonar",IdEnsayo);
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControles();
    }
  
    protected void ddlTemporada_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
    }

    protected void btnArchivo_Click(object sender, EventArgs e) {

      LlenarGrillaDoc();

      string script3 = "<script type=text/javascript> $(function () {$('#modal-default').modal('show')}); </script>";
      ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
    }

    //protected void btnFechasCosechas_Click(object sender, EventArgs e) {
    //  LlenarGrillaFecha();

    //  string script3 = "<script type=text/javascript> $(function () {$('#modal-fechas').modal('show')}); </script>";
    //  ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
    //}

    //protected void btnFechasCosechasClonar_Click(object sender, EventArgs e) {
    //  LlamarFormulario("EnsayoFechaClon", IdEnsayoRel);      
    //}

    protected void btnGuardarDoc_Click(object sender, EventArgs e) {
      InsertarDoc();
      LlenarControles();
    }
    
    protected void btnCerrarDoc_Click(object sender, EventArgs e) {
      LlenarControles();
    }
    
    protected void fluArchivo_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e) {
      File.WriteAllBytes(Path.Combine(Server.MapPath("."), fluArchivo.FileName), fluArchivo.FileBytes);

    }

    protected void btnFechaCosecha_Click(object sender, EventArgs e) {
      LlamarFormulario("EnsayoFecha", IdEnsayo);
    }

    //protected void btnModalClonar_Click(object sender, EventArgs e) {      
    //  ClonarEnsayo();
    //}
    #endregion

    #region Eventos de Grillas

    protected void dtgEnsayos_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgEnsayos.PageIndex = e.NewPageIndex;
      dtgEnsayos.DataBind();
      CargarGrilla();
    }

    protected void dtgEnsayo_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdEnsayo = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
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

    protected void dtgEnsayos_DataBound(object sender, EventArgs e) {
      if(dtgEnsayos.HeaderRow != null)
      dtgEnsayos.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgEnsayos_RowCreated(object sender, GridViewRowEventArgs e) {
     if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      } 
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}