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

  public partial class Programacion : FrmBase {

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
    int? intCantTratamientos = 0;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      if (!IsPostBack) {
        IniciarParametros();

        object objParam = TraerParametro(typeof(ProgramacionCons));

        if(objParam != null)
          intId = Convert.ToInt32(objParam);

        objParam = TraerParametro(typeof(IngresoActividad));

        if (objParam != null)
          intId = Convert.ToInt32(objParam);

        LlenarControles();
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

    //private void InsertarAct() {
    //  var tupla = Global.ObtenerFechas(txtRangoFecha);
    //  object[] objParam = new object[] {
    //    0,
    //    intId,
    //     ddlActividad.SelectedValue,
    //     tupla.Item1,
    //     tupla.Item2,
    //     ddlPrioridad.SelectedItem.Value,
    //     Global.ObtenerSeleccionados(lstDia),
    //     Global.ObtenerSeleccionados(lstTratamiento),
    //     txtObservaciones.Text
    //  };

    //  if (objApp.Ejecutar("ProgramacionActividadIns", objParam)) {
    //    ActId = (int)objParam[0];
    //    miMaster.MensajeInformacion(this);
    //    LlenarControles();
    //    LlenarControlesActividad();
    //    //CargarGrilla();
    //  } else {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //  }
    //}

    //private void ModificarAct() {
    //  var tupla = Global.ObtenerFechas(txtRangoFecha);
    //  object[] objParam = new object[] {
    //     ActId,
    //     intId,
    //     ddlActividad.SelectedValue,
    //     tupla.Item1,
    //     tupla.Item2,
    //     ddlPrioridad.SelectedItem.Value,
    //     Global.ObtenerSeleccionados(lstDia),
    //     Global.ObtenerSeleccionados(lstTratamiento),
    //     txtObservaciones.Text
    //  };

    //  if (objApp.Ejecutar("ProgramacionActividadUpd", objParam)) {
    //    miMaster.MensajeInformacion(this);
    //    LlenarControles();
    //    LlenarControlesActividad();
    //    //CargarGrilla();
    //  } else {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //  }
    //}

    private void EliminarAct() {
      object[] objParam = new object[] {
        ActId
      };

      //if (ValidarFechasProgramacionActividad(ActId)) {
      //  miMaster.MensajeError(this, Global.ERROR, "No puede eliminar actividades programadas con fecha anterior al día de hoy.");
      //} else {
        if (objApp.Ejecutar("ProgramacionActividadDel", objParam)) {
          miMaster.MensajeInformacion(this);
          LlenarControles();
          //LimpiarControlesActividad();
          //CargarGrilla();
        } else {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
        //}
      }
    }

    private void Insertar() {
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        0,
        ddlTemporada.SelectedValue,
        string.IsNullOrWhiteSpace(ddlEnsayo.SelectedValue) ? null :ddlEnsayo.SelectedValue ,
        ddlResponsable.SelectedValue,
        ddlLugar.SelectedValue,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("ProgramacionIns", objParam)) {
        miMaster.MensajeInformacion(this);
        intId = Convert.ToInt32(objParam[0]);
        LlenarControles();
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        intId,
      };

      if (objApp.Ejecutar("ProgramacionDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        intId,
        ddlTemporada.SelectedValue,
        string.IsNullOrWhiteSpace(ddlEnsayo.SelectedValue) ? null :ddlEnsayo.SelectedValue ,
        ddlResponsable.SelectedValue,
        ddlLugar.SelectedValue,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("ProgramacionUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    //private void InsertarDoc() {
    //  string strError = null;
    //  byte[] byt = FuncGen.FileToByte(Path.Combine(Server.MapPath("."), fluArchivo.FileName), ref strError);
    //  object[] objParam = new object[] {
    //    0,
    //    ActId,
    //    txtNombreArchivo.Text,
    //    fluArchivo.FileName,
    //    byt,
    //    chkObligatorio.Checked
    //  };

    //  if (objApp.Ejecutar("ProgramacionActividadDocIns", objParam)) {
    //    miMaster.MensajeInformacion(this);
    //    LimpiarControlesDoc();
    //    LlenarGrillaDoc();
    //    LlenarControlesActividad();
    //    File.Delete(Path.Combine(Server.MapPath("."), fluArchivo.FileName));

    //  } else {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //  }
    //}

    //private void EliminarDoc(int intIdDoc) {
    //  object[] objParam = new object[] {
    //    intIdDoc
    //  };

    //  if (objApp.Ejecutar("ProgramacionActividadDocDel", objParam)) {
    //    miMaster.MensajeInformacion(this);
    //    LlenarGrillaDoc();
    //    LlenarControlesActividad();
    //  } else {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //  }
    //}
    #endregion

    #region Interfaz     

    #region Ddls

    private void LlenarDdls() {
      LlenarddlResponsable(false);
      LlenarddlTemporada(false);
      //LlenarddlDia(false);
      //LlenarddlActividad(false, "");
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

    private bool LlenarddlEnsayo(bool bolMostrarMensaje, int intIdLugar) {
      DataTable dt = objApp.TraerTabla("CacheEnsayo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Codigo");
        }

      ddlEnsayo.DataSource = new DataView(dt, string.Format("IdLugar={0} or Id is null", intIdLugar), "Codigo", DataViewRowState.OriginalRows);
      ddlEnsayo.DataBind();


      //ddlPrueba.DataSource = new DataView(dt, "Id > 0", "Nombre", DataViewRowState.OriginalRows);
      //ddlPrueba.DataBind();
      return true;
    }

    private bool LlenarddlLugar(bool bolMostrarMensaje, int intIdTemporada) {
      DataTable dt = objApp.TraerTabla("CacheLugar");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Nombre");
        }

      ddlLugar.DataSource = new DataView(dt, string.Format("IdTemporada={0}", intIdTemporada), "Nombre", DataViewRowState.OriginalRows);
      ddlLugar.DataBind();

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

      ddlResponsable.DataSource = new DataView(dt, "", "usu_usuario", DataViewRowState.OriginalRows);
      ddlResponsable.DataBind();

      return true;
    }

    //private bool LlenarddlDia(bool bolMostrarMensaje) {
    //  DataTable dt = objApp.TraerTabla("CacheDia");

    //  if (dt == null && bolMostrarMensaje) {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

    //    return false;
    //  }

    //  if (dt == null) {
    //    dt = new DataTable();
    //    dt.Columns.Add("Id");
    //    dt.Columns.Add("Dia");
    //  }

    //  dt.Columns.Add("Sel", typeof(bool));

    //  lstDia.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
    //  lstDia.DataBind();

    //  return true;
    //}

    //private bool LlenarddlPrioridad(bool bolMostrarMensaje) {
    //  DataTable dt = objApp.TraerTabla("CacheProgramacionPrioridad");

    //  if (dt == null && bolMostrarMensaje) {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

    //    return false;
    //  }

    //  if (dt == null) {
    //    dt = new DataTable();
    //    dt.Columns.Add("Id");
    //    dt.Columns.Add("Prioridad");
    //  }

    //  ddlPrioridad.DataSource = new DataView(dt, "Id > 0", "Id", DataViewRowState.OriginalRows);
    //  ddlPrioridad.DataBind();

    //  return true;
    //}

    //private bool LlenarddlActividad(bool bolMostrarMensaje, string strNuevo) {
    //  DataTable dt = objApp.TraerTabla("CacheActividad");

    //  if (dt == null && bolMostrarMensaje) {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

    //    return false;
    //  }

    //  if (dt == null) {
    //    dt = new DataTable();
    //    dt.Columns.Add("Nombre");
    //  }

    //  if (!string.IsNullOrWhiteSpace(strNuevo)) {
    //    DataRow dtr = dt.NewRow();
    //    dtr["Nombre"] = strNuevo;
    //    dt.Rows.Add(dtr);
    //    dt.AcceptChanges();
    //  }

    //  ddlActividad.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
    //  ddlActividad.DataBind();

    //  if (!string.IsNullOrWhiteSpace(strNuevo)) {
    //    ddlActividad.SelectedValue = strNuevo;
    //    txtNuevaActividad.Text = "";
    //  }

    //  return true;
    //}
    #endregion

    private void LimpiarControles() {
      intId = -1;
      ddlEnsayo.SelectedIndex = 0;
      ddlLugar.SelectedIndex = 0;
      ddlResponsable.SelectedIndex = 0;
      //ddlPrioridad.SelectedIndex = 0;
      //txtRangoFecha.Text = "";
      //txtObservaciones.Text = "";
      btnGuardar.Enabled = true;
      btnEliminar.Enabled = false;
      btnNuevo.Enabled = false;
      cardActividades.Visible = false;
      //btnArchivo.Text = "0 Archivo(s)";
    }

    private void LlenarControles() {
      DataSet dts = objApp.TraerDataset("ProgramacionSel_Id", new object[] { intId });

      if (dts != null) {

        if (dts.Tables[0].Rows.Count == 0) {
          LimpiarControles();
          return;
        }

        DataRow dtr = dts.Tables[0].Rows[0];
        dtgActividades.DataSource = dts.Tables[1].DefaultView;
        dtgActividades.DataBind();

        ddlTemporada.SelectedValue = dtr["IdTemporada"].ToString();
        LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
        ddlLugar.SelectedValue = dtr["IdLugar"].ToString();
        LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
        ddlEnsayo.SelectedValue = dtr["IdEnsayo"].ToString();
        //ddlPrioridad.SelectedValue = dtr["IdPrioridad"].ToString();
        ddlResponsable.SelectedValue = dtr["IdResponsable"].ToString();
        intCantTratamientos = dtr["CantTratamiento"] as int?;

        //DataTable dtTratamientos = new DataTable();
        //dtTratamientos.Columns.Add("Id", typeof(int));

        //if (intCantTratamientos.HasValue) {

        //  for (int i = 1; i <= intCantTratamientos; i++) {
        //    dtTratamientos.Rows.Add(i);
        //  }
        //}

        //lstTratamiento.DataSource = dtTratamientos.DefaultView;
        //lstTratamiento.DataBind();

        if (intId == 0) {
          btnNuevo.Enabled = true;
        } else {
          btnNuevo.Enabled = false;
        }
        btnGuardar.Enabled = true;
        btnEliminar.Enabled = true;
        //txtRangoFecha.Text= string.Format("{0} - {1}", ((DateTime)dtr["FechaDesde"]).ToString("dd/MM/yyyy") , ((DateTime)dtr["FechaHasta"]).ToString("dd/MM/yyyy"))   ;
        cardActividades.Visible = true;

      }

    }

    //private void LlenarControlesActividad() {
    //  DataSet dts = objApp.TraerDataset("ProgramacionActividadSel_Id", new object[] { ActId });

    //  if (dts != null) {

    //    if (dts.Tables[0].Rows.Count == 0) {
    //      LimpiarControlesActividad();
    //      return;
    //    }

    //    DataRow dtr = dts.Tables[0].Rows[0];

    //    ddlActividad.SelectedValue = dtr["Actividad"].ToString();
    //    ddlPrioridad.SelectedValue = dtr["IdPrioridad"].ToString();
    //    intCantTratamientos = dtr["CantTratamiento"] as int?;
    //    txtObservaciones.Text = dtr["Observacion"].ToString();

    //    txtRangoFecha.Text = string.Format("{0} - {1}", ((DateTime)dtr["FechaDesde"]).ToString("dd/MM/yyyy"), ((DateTime)dtr["FechaHasta"]).ToString("dd/MM/yyyy")) ;
    //    lstDia.ClearSelection();

    //    string strTratamientos = dtr["Tratamiento"].ToString();

    //    if (!string.IsNullOrWhiteSpace(strTratamientos)) {
    //      strTratamientos.Split('|').ToList().ForEach(s => { if(!string.IsNullOrWhiteSpace(s))  lstTratamiento.Items.FindByValue(s).Selected = true; });
    //    }


    //    dts.Tables[1].AsEnumerable().ToList().ForEach(s => lstDia.Items.FindByValue(s["IdDia"].ToString()).Selected = true );

    //    btnArchivo.Text = string.Format("{0} Archivo(s)", dtr["CantArchivos"]);


    //    foreach (DataRow item in dts.Tables[2].Rows) {
    //      HyperLink lnk = new HyperLink() { CssClass = "dropdown-item", ID = item["Id"].ToString(), Text = item["Nombre"].ToString() };
    //      lnk.NavigateUrl = "ProgramacionActividadDoc?IdDoc=" + lnk.ID;
    //      menuVer.Controls.Add(lnk);
    //    }
    //  }

    //}

    //private void LimpiarControlesActividad() {
    //  ActId = -1;

    //  ddlActividad.SelectedIndex = -1;
    //  ddlPrioridad.SelectedIndex = -1;

    //  txtRangoFecha.Text = "";
    //  lstDia.ClearSelection();
      
    //  btnArchivo.Text = "0 Archivo(s)";
    //  btnEliminarAct.Enabled = false;
    //  btnActualizarAct.Enabled = false;
    //}

    //private void LimpiarControlesDoc() {
    //  txtNombreArchivo.Text = "";
    //  chkObligatorio.Checked = false;
    //}

    //private void EnviarDoc(int intIdDoc) {

    //  DataTable dt = objApp.TraerTabla("ProgramacionActividadDocSel_IdDoc", new object[] { intIdDoc });

    //  if (dt != null) {

    //    DataRow dtr = dt.Rows[0];

    //    Response.Clear();
    //    Response.AddHeader("Content-Disposition", "attachment;filename=\"" + dtr["NombreArchivo"].ToString() + "\"");
    //    // edit this line to display ion browser and change the file name
    //    Response.BinaryWrite((byte[])dtr["Archivo"]);
    //    // gets our pdf as a byte array and then sends it to the buffer
    //    Response.Flush();
    //    Response.End();
    //  }

    //}

    //private void LlenarGrillaDoc() {

    //  DataTable dttTabla = objApp.TraerTabla("DocProgramacionActividadSel_Grids", new object[] { ActId });

    //  if (dttTabla != null) {
    //    RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
    //  } else {
    //    if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
    //      miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //      return;
    //    }
    //  }
    //}

    //private bool Validar() {
    //  StringBuilder stbError = new StringBuilder();

    //    var tupla = Global.ObtenerFechas(txtRangoFecha);
    //    if ((tupla.Item2 - tupla.Item1).TotalDays != 7)
    //      stbError.Append("El rango de fecha debe ser de 7 días <br>");
    //    else if (tupla.Item1.DayOfWeek != DayOfWeek.Monday)
    //      stbError.Append("El rango de fecha debe comenzar con el día lunes <br>");

    //  if (stbError.Length > 0) {
    //    stbError.Insert(0, "Existen campos con errores: <br>");
    //    miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
    //    return false;
    //  }
    //  return true;
    //}

    private bool ValidarFechasProgramacionActividad(int ProgActId) {

      DataSet dt = objApp.TraerDataset("ValidarFechasProgramacionActividad", new object[] { ProgActId });

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
      //if (!Validar())
      //  return;

      if (intId <= 0)
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

    protected void btnAgregarAct_Click(object sender, EventArgs e) {
      LlamarFormulario("IngresoActividad.aspx", new object[] {intId, ActId, Convert.ToInt32(ddlLugar.SelectedValue) });
    }

    protected void ddlEnsayo_SelectedIndexChanged(object sender, EventArgs e) {
      DataTable dt = objApp.TraerTabla("CacheEnsayo");
      DataRow dtr = dt.AsEnumerable().Where(s => !s.IsNull("Id") && (int)s["Id"] == Convert.ToInt32(ddlEnsayo.SelectedValue)).SingleOrDefault();

      ddlResponsable.SelectedValue = dtr["IdResponsable"].ToString();
    }
    
    protected void ddlTemporada_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }

    protected void ddlLugar_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }
    
    #endregion

    #region Eventos de Grillas

    protected void dtgActividades_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Modificar") {
        ActId = Convert.ToInt32(e.CommandArgument);
        LlamarFormulario("IngresoActividad.aspx", new object[] { intId, ActId, Convert.ToInt32(ddlLugar.SelectedValue) });
        //btnEliminarAct.Enabled = true;
        //btnActualizarAct.Enabled = true;
        //LlenarControlesActividad();
      }
    }

    protected void dtgActividades_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgActividades.PageIndex = e.NewPageIndex;
      dtgActividades.DataBind();
      //LlenarControlesActividad();
    }

    //protected void dtgDocs_RowCommand(object sender, GridViewCommandEventArgs e) {
    //  int intIdDoc = Convert.ToInt32(e.CommandArgument);
    //  if (e.CommandName == "Eliminar") {
    //    EliminarDoc(intIdDoc);
    //  } else if (e.CommandName == "Visualizar") {
    //    EnviarDoc(intIdDoc);
    //  }
    //}

    protected void dtgActividades_DataBound(object sender, EventArgs e) {
      if(dtgActividades.HeaderRow != null)
      dtgActividades.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividades_RowCreated(object sender, GridViewRowEventArgs e) {


      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}