
using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Windows;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using ITD.Web;
using ITD.Funciones;
using System.IO;
using ITD.Log;
using System.Drawing;
using System.Globalization;
using System.Web.Services;

namespace WEB {
  public partial class RegistroActividad : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int ProgActId = 0;
    int RegActEstado = 0;

    enum COL_PRODUCTO {
      Codigo,
      Descripcion,
      Bodega,
      Stock,
      Vence,
      Cantidad,
      Merma
    }

    enum COL_EXTERNO{
      Codigo,
      Descripcion,
      Cantidad,
    }

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniRegistroActividad", "mniRegistroActividad");
   
      if (!IsPostBack) {

        string str = Request.QueryString["IdDoc"];

        if (!string.IsNullOrWhiteSpace(str)) {
          EnviarDoc(Convert.ToInt32(str));
        }

        LlenarDdls();
        InicializarFiltros();

        IniciaParametros();
        object objParam = TraerParametro(typeof(Forma));

        if (objParam != null) {
          object[] objFechas = (object[])objParam;
          DateTime dtFechaMin = (DateTime)objFechas[0];
          DateTime dtFechaMax = (DateTime)objFechas[1];

          txtFechaDesde.Text = dtFechaMin.ToString("dd/MM/yyyy");
          txtFechaHasta.Text = dtFechaMax.ToString("dd/MM/yyyy");

        }

        dtgPrincipal.PageSize = 20;

        Filtrar();

      } else {
        //dttDdls = (DataTable)ViewState["dttDdls"];
        ProgActId = Convert.ToInt32(ViewState["ProgActId"]);
        RegActEstado = Convert.ToInt32(ViewState["RegActEstado"]);
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("ProgActId", ProgActId);
      ViewState.Add("RegActEstado", RegActEstado);
    }

    public override void InicializarFiltros() {
      base.InicializarFiltros();

      Filtro.Agregar(new FiltroTextBox(txtFechaDesde, OpcSeleccion.ControlConValor, TipoOperadores.MayorIgual, "ProgramacionActividadRegistro.Fecha", "FechaDesde", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroTextBox(txtFechaHasta, OpcSeleccion.ControlConValor, TipoOperadores.MenorIgual, "ProgramacionActividadRegistro.Fecha", "FechaHasta", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroDropDown(ddlTemporada, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdTemporada", "Temporada", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlLugar, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdLugar", "Lugar", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlEnsayo, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdEnsayo", "Ensayo", TipoDatos.Entero));
      

    }

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);


      txtFechaDesde.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
      txtFechaHasta.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
      this.SalvaForma = true;

    }

    #endregion

    #region ddls
    private void LlenarDdls() {
      LlenarddlMotivo(false);
      LlenarddlTemporada(false);  
    }

    private bool LlenarddlMotivo(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheProgramacionActividadMotivo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Motivo");
      }

      ddlMotivo.DataSource = new DataView(dt, "Id > 0", "Motivo", DataViewRowState.OriginalRows);
      ddlMotivo.DataBind();

      return true;
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

      ddlTemporada.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
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
    #endregion

    #region List

    private void LlenarLists() {
      LlenarlstResponsable(false);
      LlenarlstAuxiliares(false);
    }

    private bool LlenarlstResponsable(bool bolMostrarMensaje) {
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
        }

      lstResponsables.DataSource = new DataView(dt, "Id > 0", "nombre_empleado", DataViewRowState.OriginalRows);
      lstResponsables.DataBind();

      return true;
    }

    private bool LlenarlstAuxiliares(bool bolMostrarMensaje) {
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
        }

      lstAuxiliares.DataSource = new DataView(dt, "Id > 0", "nombre_empleado", DataViewRowState.OriginalRows);
      lstAuxiliares.DataBind();

      return true;
    }    
   
    #endregion

    #region Actualizar        

    private void Cancelar(string strIds, string strFechas, int RegActEstado) {
      //DateTime? dtDesde = null;

      //if (chkReprogramar.Checked && string.IsNullOrWhiteSpace(txtFechaReprog.Text)) {

      //  string[] strSplit = txtFechaDesde.Text.Split('/');
      //  dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));
      //}
      object[] objParam = new object[] {
        0,
        ProgActId,
        null,
        objApp.InfoUsr.IdUsuario,
        RegActEstado,
        txtObservacion.Text,
        string.IsNullOrEmpty(ddlMotivo.SelectedValue) ? null : ddlMotivo.SelectedValue,
        //dtDesde,
        strIds,
        strFechas
      };

      if (objApp.Ejecutar("ProgramacionActividadRegistroIns", objParam)) {
        miMaster.MensajeInformacion(this);
        Filtrar();
      } else {
        miMaster.MensajeError(this, "ERROR", ProcesarError(objApp.UltimoError));

      }
    }

    
    private void Finalizar(string strProgActId, string strFechaTexto, int RegActEstado) {
      
      object[] objParam = new object[] {
        0,
        strProgActId,
        strFechaTexto,
        RegActEstado,
        Global.ObtenerSeleccionados(lstResponsables),
        Global.ObtenerSeleccionados(lstAuxiliares),
        txtFechaEjecucion.Text,
        objApp.InfoUsr.IdUsuario,
        XMLProd(),
        XMLHerramienta(),
        XMLExterno(),
        XMLTodos()
      };

      if (objApp.Ejecutar("ProgramacionActividadRegistroUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        Filtrar();
      } else {
        miMaster.MensajeError(this, "ERROR", ProcesarError(objApp.UltimoError));

      }
    }

    //private void InsertarDoc(string IdsProgActivDocs, string Ensayo, string IdsProgActiv, string strFecha) {
    //  string strError = null;
    //  byte[] byt = FuncGen.FileToByte(Path.Combine(Server.MapPath("."), fluArchivo.FileName), ref strError);
    //  object[] objParam = new object[] {
    //    0,
    //    Convert.ToInt32(IdsProgActivDocs),
    //    Convert.ToInt32(Ensayo),
    //    Convert.ToInt32(IdsProgActiv),
    //    strFecha,
    //    txtNombreArchivo.Text,
    //    fluArchivo.FileName,
    //    byt,
    //    0
    //  };

    //  if (objApp.Ejecutar("ProgramacionActividadRegistroDocIns", objParam)) {
    //    miMaster.MensajeInformacion(this);
    //    File.Delete(Path.Combine(Server.MapPath("."), fluArchivo.FileName));

    //  } else {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //  }      
    //}

    private void EliminarDocSubir(int intId) {
      object[] objParam = new object[] {
        intId
      };

      if (objApp.Ejecutar("ProgramacionActividadRegistroDocDel", objParam)) {
        miMaster.MensajeInformacion(this);
        // LlenarGrillaDocSubir();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void InsertarReprogramacion() {

      //programar si la fecha está dentro del rango, insertar registro el día en la tabla ProgramacionDia.
      //Si la fecha está fuera del rango de fecha, insertar registro en ProgramacionActividad. Y en AsignacionActividad
      //  asignar el usuario.
    }


    #endregion

    #region Interfaz        

    private void LimpiarControles() {

      ddlMotivo.SelectedIndex = -1;
      txtObservacion.Text = null;
    }

    private void Filtrar() {

      if (Filtro == null)
        InicializarFiltros();
      string strError = Filtro.ValidarFiltros();
      if (string.IsNullOrEmpty(strError)) {
        Filtro.FormarFiltro();
        LlenarGrilla();

        foreach (GridViewRow item in dtgPrincipal.Rows) {
          DateTime dtFecha;

          DateTime.TryParseExact(dtgPrincipal.DataKeys[item.RowIndex].Values[1].ToString(), "yyyyMMdd", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

          if (ValidarSubidaArchivos((int)dtgPrincipal.DataKeys[item.RowIndex].Values[0], dtFecha)) {
            item.BackColor = Color.LightGreen;
          }
        }
      }
    }

    private void LlenarGrilla() {
      object[] objParam;

      objParam = new object[]{
        dtgPrincipal.PageIndex,
        dtgPrincipal.PageSize,
        0,
        TomarOrdenGrilla(dtgPrincipal),
        Filtro.Filtro,
        null,
        objApp.InfoUsr.IdUsuario
      };

      DataTable dtsTabla = objApp.TraerTabla("ProgramacionActividadSel_Grids", objParam, 60);

      if (dtsTabla != null) {

        dtgPrincipal.PageIndex = (int)objParam[0];
        RefrescarGrilla(dtgPrincipal, dtsTabla.DefaultView, (int)objParam[2]);

      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          //PopUpModal.Show();
          return;
        }
      }

    }

    private bool ValidarSubidaArchivos(int IdProgAct, DateTime dtFecha) {

      DataSet dt = objApp.TraerDataset("ValidacionRegistroDocSel_Id", new object[] { IdProgAct, dtFecha });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
                
        return true;
      }
      
      return false; 
    }

    //private void LlenarGrillaDoc(string strIdsProgAct, string strFechas) {
    //  object[] objParam = new object[] { 0, strIdsProgAct, strFechas };

    //  DataTable dttTabla = objApp.TraerTabla("ProgramacionActividadDocSel_Grids", objParam, 60);

    //  if (dttTabla != null) {
    //    RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
    //  } else {
    //    if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
    //      miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //      return;
    //    }
    //  }
    //}

    //private void LlenarGrillaDocSubir(string strIdsProgAct, string strFechas) {
    //  object[] objParam = new object[] { 0, strIdsProgAct, strFechas };

    //  DataTable dttTabla = objApp.TraerTabla("ProgramacionActividadRegistroDocSel_Grids", objParam);

    //  if (dttTabla != null) {
    //    RefrescarGrilla(dtgDocsSubir, dttTabla.DefaultView, false);
    //  } else {
    //    if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
    //      miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
    //      return;
    //    }
    //  }
    //}
    

    private void EnviarDoc(int intIdDoc) {

      DataTable dt = objApp.TraerTabla("ProgramacionActividadDocSel_Id", new object[] { intIdDoc });

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

    private void EnviarDocSubir(int intIdDoc) {

      DataTable dt = objApp.TraerTabla("ProgramacionActividadRegistroDocSel_Id", new object[] { intIdDoc });

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

    private bool ValidarCampex(string IdsProgAct, string FechaTexto) {
      DataSet dt = objApp.TraerDataset("ValidacionCampexSel_Id", new object[] { IdsProgAct, FechaTexto });

      if (dt != null && dt.Tables[0].Rows.Count > 1) {

        return true;
      }

      return false;
    }

    private bool ValidarControles() {
      StringBuilder stbError = new StringBuilder();

      DateTime dtFechaEjecucion;

      if (string.IsNullOrWhiteSpace(txtFechaEjecucion.Text))
        stbError.AppendLine("Fecha de siembra es requerida");
      else if (!DateTime.TryParse(txtFechaEjecucion.Text, out dtFechaEjecucion))
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

    public byte[] ReadFully(Stream input) {
      byte[] result;
      using (var streamReader = new MemoryStream()) {
        input.CopyTo(streamReader);
        result = streamReader.ToArray();
      }

      return result;
    }
    
    public bool OnSubmit(DateTime dtFecha) {

      DataTable dt = objApp.TraerTabla("RegistroActividadPeriodoVal", new object[] { txtIdProgAct.Text, dtFecha });

      if (dt == null || dt.Rows.Count == 0)
        return false;
      
        return true;
    }

    private void LlenarGrillasProdHerr(string  strIds) {
      DataSet dts = objApp.TraerDataset("ProgramacionRegistroActividadProdHerr_Sel", new object[] { strIds });

      if (dts == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgProductos, dts.Tables[0].DefaultView, false);
        RefrescarGrilla(dtgTodos, dts.Tables[1].DefaultView, false);
        RefrescarGrilla(dtgHerramientas, dts.Tables[2].DefaultView, false);
        RefrescarGrilla(dtgExterno, dts.Tables[3].DefaultView, false);
      }

    }

    private string XMLProd() {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtgProductos.Rows) {
        var txt = (TextBox)item.Cells[(int)COL_PRODUCTO.Cantidad].Controls[1];
        var txtMerma = (TextBox)item.Cells[(int)COL_PRODUCTO.Merma].Controls[1];

        decimal? decValor = Global.convertiraNumero(txt.Text);
        decimal? decValorMerma = Global.convertiraNumero(txtMerma.Text);


        if (decValor.HasValue && decValor.Value > 0)
          stb.AppendFormat("<v IdProd=\"{0}\" IdBodega=\"{2}\" Valor=\"{1}\" Merma=\"{3}\" Vence=\"{4}\" />", dtgProductos.DataKeys[item.RowIndex].Values[0], decValor.Value.ToString("##0.##"), dtgProductos.DataKeys[item.RowIndex].Values[1], decValorMerma.Value.ToString("##0.##"), dtgProductos.DataKeys[item.RowIndex].Values[2]);
      }

      return stb.ToString();

    }

    private string XMLHerramienta() {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtgHerramientas.Rows) {
        var txt = (TextBox)item.Cells[4].Controls[1];
        var txtMerma = (TextBox)item.Cells[5].Controls[1];


        decimal? decValor = Global.convertiraNumero(txt.Text);
        decimal? decValorMerma = Global.convertiraNumero(txtMerma.Text);


        if (decValor.HasValue && decValor.Value > 0)
          stb.AppendFormat("<v IdHerr=\"{0}\" IdBodega=\"{2}\" Valor=\"{1}\" Merma=\"{3}\" />", dtgHerramientas.DataKeys[item.RowIndex].Values[0], decValor.Value.ToString("##0.##"), dtgHerramientas.DataKeys[item.RowIndex].Values[1], decValorMerma.Value.ToString("##0.##"));
      }

      return stb.ToString();

    }

    private string XMLExterno() {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtgExterno.Rows) {
        var txt = (TextBox)item.Cells[(int)COL_EXTERNO.Cantidad].Controls[1];

        decimal? decValor = Global.convertiraNumero(txt.Text);


        if (decValor.HasValue && decValor.Value > 0)
          stb.AppendFormat("<v IdProd=\"{0}\"  Valor=\"{1}\" />", dtgProductos.DataKeys[item.RowIndex].Value, decValor.Value.ToString("##0.##"));
      }

      return stb.ToString();

    }

    private string XMLTodos() {
      StringBuilder stb = new StringBuilder();
      foreach (GridViewRow item in dtgProductos.Rows) {
        var txt = (TextBox)item.Cells[(int)COL_PRODUCTO.Cantidad].Controls[1];

        decimal? decValor = Global.convertiraNumero(txt.Text);
        
        if (decValor.HasValue && decValor.Value > 0)
          stb.AppendFormat("<v IdProd=\"{0}\" IdBodega=\"{2}\" Valor=\"{1}\" Vence=\"{3}\" />", dtgProductos.DataKeys[item.RowIndex].Values[0], decValor.Value.ToString("##0.##"), dtgProductos.DataKeys[item.RowIndex].Values[1], dtgProductos.DataKeys[item.RowIndex].Values[2]);
      }

      return stb.ToString();

    }

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnFiltrar_Click(object sender, EventArgs e) {
      Filtrar();
    }


    protected void btnGuardarModalCancelar_Click(object sender, EventArgs e) {
      StringBuilder stb = new StringBuilder();
      StringBuilder stb2 = new StringBuilder();
      foreach (GridViewRow item in dtgPrincipal.Rows) {
        if (((CheckBox)item.Cells[0].Controls[0]).Checked) {
          stb.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[0]); //IdProgramacionActividad
          stb2.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[1]);//FechaDiaTexto
        }
      }

      if (stb.Length > 0)
        stb.Remove(stb.Length - 1, 1);

      if (stb2.Length > 0)
        stb2.Remove(stb2.Length - 1, 1);

      int RegActEstado = (int)ESTADO_REGISTRO_ACTIVIDAD.Cancelado;

      Cancelar(stb.ToString(), stb2.ToString(), RegActEstado);
      LimpiarControles();
    }

    //protected void chkReprogramar_CheckedChanged(object sender, EventArgs e) {
    //  FechaProgra.Visible = chkReprogramar.Checked;
    //}

    //protected void btnGuardarModalDoc_Click(object sender, EventArgs e) { 
    //  int contador = 0;
    //  StringBuilder stb = new StringBuilder();
    //  StringBuilder stb2 = new StringBuilder();
    //  StringBuilder stb3 = new StringBuilder();
    //  StringBuilder stb4 = new StringBuilder();
    //  StringBuilder stb5 = new StringBuilder();

    //  foreach (GridViewRow row in dtgDocs.Rows) {
    //    if (row.RowIndex == dtgDocs.SelectedIndex) {
    //      stb.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[0]); //IdProgramacionActividadDoc
    //      stb2.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[2]);//IdProgramacionActividad
    //      stb3.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[3]);//IdProgramacionActividadRegistro
    //      stb4.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[1]);//FechaTexto
    //      stb5.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[4]);//Ensayo
    //      contador = contador + 1;
    //    } 
    //  }

    //  if (contador > 0) {

    //    if (stb.Length > 0)
    //      stb.Remove(stb.Length - 1, 1);

    //    if (stb2.Length > 0)
    //      stb2.Remove(stb2.Length - 1, 1);

    //    if (stb3.Length > 0)
    //      stb3.Remove(stb3.Length - 1, 1);

    //    if (stb4.Length > 0)
    //      stb4.Remove(stb4.Length - 1, 1);

    //    if (stb5.Length > 0)
    //      stb5.Remove(stb5.Length - 1, 1);

    //    InsertarDoc(stb.ToString(), stb5.ToString(), stb2.ToString(), stb4.ToString());
    //    txtNombreArchivo.Text = null;
    //    LlenarGrillaDoc(stb2.ToString(), stb4.ToString());
    //    LlenarGrillaDocSubir(stb2.ToString(), stb4.ToString());
    //  }
    //}

    //protected void btnCerrarModalDoc_Click(object sender, EventArgs e) {
    //  Filtrar();
    //}

    //protected void fluArchivo_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e) {
    //  File.WriteAllBytes(Path.Combine(Server.MapPath("."), fluArchivo.FileName), fluArchivo.FileBytes);

    //}

    protected void btnArchivos_Click(object sender, EventArgs e) {      

      //string script3 = "<script type=text/javascript> $(function () {$('#modal-archivos').modal('show')}); </script>";
      //ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);

      StringBuilder stb = new StringBuilder();
      StringBuilder stb2 = new StringBuilder();
      foreach (GridViewRow item in dtgPrincipal.Rows) {
        if (((CheckBox)item.Cells[0].Controls[0]).Checked) {
          stb.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[0]); //IdProgramacionActividad
          stb2.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[1]);//FechaDiaTexto
        }
      }

      if (stb.Length > 0)
        stb.Remove(stb.Length - 1, 1);

      if (stb2.Length > 0)
        stb2.Remove(stb2.Length - 1, 1);

      //LlenarGrillaDoc(stb.ToString(), stb2.ToString());
      //LlenarGrillaDocSubir(stb.ToString(), stb2.ToString());

      LlamarFormulario("SubirArchivosRegAct.aspx", new object[] { stb.ToString(), stb2.ToString() });      
    }

    protected void btnFinalizar_Click(object sender, EventArgs e) {
      int contador = 0;
      Color ColorFila = Color.White;

      StringBuilder stb = new StringBuilder();
      StringBuilder stb2 = new StringBuilder();
      StringBuilder stbIdReg = new StringBuilder();
      foreach (GridViewRow item in dtgPrincipal.Rows) {
        if (((CheckBox)item.Cells[0].Controls[0]).Checked) {
          stb.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[0]); //IdProgramacionActividad
          stb2.AppendFormat("{0}|", dtgPrincipal.DataKeys[item.RowIndex].Values[1]);//FechaDiaTexto
          stbIdReg.AppendFormat("{0},", dtgPrincipal.DataKeys[item.RowIndex].Values[5]);//FechaDiaTexto
          contador = contador + 1;
          ColorFila = item.BackColor;
        }
      }
      
      if (stb.Length > 0)
        stb.Remove(stb.Length - 1, 1);

      if (stb2.Length > 0)
        stb2.Remove(stb2.Length - 1, 1);
      if (stbIdReg.Length > 0)
        stbIdReg.Remove(stbIdReg.Length - 1, 1);
      //if (contador > 1) {
      //  miMaster.MensajeError(this, Global.ERROR, "Debe seleccionar solo una actividad para finalizar");
      //} else {
      if (ColorFila != Color.LightGreen) {
        miMaster.MensajeError(this, Global.ERROR, "No puede finalizar la actividad. No se han subido los archivos obligatorios.");
      } else {
        txtIdProgAct.Text = stb.ToString();
        hdfIdPrograAct.Value = stb.ToString();
        txtFechaTexto.Text = stb2.ToString();

        if (ValidarCampex(txtIdProgAct.Text, txtFechaTexto.Text)) {
          miMaster.MensajeError(this, Global.ERROR, "Solo se pueden finalizar registros que tengan la misma actividad, fecha, ensayo y lugar.");
          return;
        } else {
          LlenarGrillasProdHerr(stbIdReg.ToString());
          LlenarLists();
          ScriptManager.RegisterStartupScript(Page, Page.GetType(), "FinalizarRegistroActividad", "$(\"#FinalizarRegistroActividad\").modal(\"show\");", true);
        }
      }
      //}
    }

    protected void btnGuardarModalFinalizar_Click(object sender, EventArgs e) {

      if (!ValidarControles())
        return;

      int RegActEstado = (int)ESTADO_REGISTRO_ACTIVIDAD.Finalizado;
      Finalizar(txtIdProgAct.Text, txtFechaTexto.Text, RegActEstado);
      LimpiarControles();
    }

    protected void btnCancelar_Click(object sender, EventArgs e) {

      ScriptManager.RegisterStartupScript(Page, Page.GetType(), "CancelarRegistroActividad", "$(\"#CancelarRegistroActividad\").modal(\"show\");", true);
      LlenarDdls();
    }

    //protected void btnDescargar_Click(object sender, EventArgs e) {
    //  foreach (GridViewRow row in dtgDocs.Rows) {
    //    if (row.RowIndex == dtgDocs.SelectedIndex) {
    //      int intIdDoc = Convert.ToInt32(dtgDocs.DataKeys[row.RowIndex].Value);
    //      EnviarDoc(intIdDoc);
    //    }
    //  }
    //}

    protected void ddlTemporada_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }

    protected void ddlLugar_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }

    protected void txtFechaEjecucion_TextChanged(object sender, EventArgs e) {
      lblPeriodo.Visible = false;
      try {

        string[] strSplit = txtFechaEjecucion.Text.Split('/');
        DateTime dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));


        lblPeriodo.Visible = OnSubmit(dtDesde);
        

      } catch (Exception ex) {

        throw;
      }
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgPrincipal_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgPrincipal.PageIndex = e.NewPageIndex;
      dtgPrincipal.DataBind();
      Filtrar();

    }

    protected void dtgPrincipal_Sorting(object sender, GridViewSortEventArgs e) {
      SetearOrdenGrilla(dtgPrincipal, e.SortExpression);
      Filtrar();
    }

    protected void dtgPrincipal_RowDataBound(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowIndex == -1) return;

      ((CheckBox)e.Row.Cells[0].Controls[0]).Enabled = true;

      if (e.Row.RowType == DataControlRowType.DataRow) {
        DateTime dtFecha = DateTime.MinValue;

        DateTime.TryParseExact(e.Row.Cells[1].Text, "dd-MM-yyyy", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

        e.Row.Cells[1].Attributes.Add("data-order", dtFecha.Ticks.ToString());
      }

    }

    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      if (dtgPrincipal.HeaderRow != null)
        dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;

    }

    public void dtgPrincipal_RowCommand(object sender, GridViewCommandEventArgs e) {
      ProgActId = Convert.ToInt32(e.CommandArgument);      
      
    }

    protected void dtgPrincipal_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }


    //protected void dtgDocs_RowDataBound(object sender, GridViewRowEventArgs e) {

    //  if (e.Row.RowType == DataControlRowType.DataRow) {
    //    e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(dtgDocs, "Select$" + e.Row.RowIndex);
    //    e.Row.ToolTip = "Click to select this row.";
    //  }
    //}

    //protected void dtgDocs_PageIndexChanging(object sender, GridViewPageEventArgs e) {
    //  dtgDocs.SelectedIndex = -1;
    //}

    //protected void dtgDocs_OnSelectedIndexChanged(object sender, EventArgs e) {
    //  foreach (GridViewRow row in dtgDocs.Rows) {
    //    if (row.RowIndex == dtgDocs.SelectedIndex) {          
    //      row.BackColor = ColorTranslator.FromHtml("#A1DCF2");
    //      row.ToolTip = string.Empty;
    //      txtNombreArchivo.Text = dtgDocs.Rows[row.RowIndex].Cells[0].Text;
    //    } else {
    //      row.BackColor = ColorTranslator.FromHtml("#FFFFFF");
    //      row.ToolTip = "Seleccione este registro";
    //    }
    //  }
    //}

    //protected void dtgDocs_RowCommand(object sender, GridViewCommandEventArgs e) {
    //  if (e.CommandName == "Descargar") {
    //    foreach (GridViewRow row in dtgDocs.Rows) {
    //      if (row.RowIndex == dtgDocs.SelectedIndex) {
    //        int intIdDoc = Convert.ToInt32(dtgDocs.DataKeys[row.RowIndex].Value);
    //        EnviarDoc(intIdDoc);
    //      }
    //    }
    //  }
    //}

    //protected void dtgDocsSubir_RowCommand(object sender, GridViewCommandEventArgs e) {
    //  int intIdDoc = Convert.ToInt32(e.CommandArgument);
    //  if (e.CommandName == "Eliminar") {
    //    EliminarDocSubir(intIdDoc);
    //    UpdatePanel2.Update();
    //  } else if (e.CommandName == "Visualizar") {
    //    EnviarDocSubir(intIdDoc);
    //  }
    //}


    #endregion

    #region Persistencia 

    #endregion

  }
    
}