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

namespace WEB {
  public partial class SubirArchivosRegAct : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int ProgActId = 0;
    int intIdUsuario = 0;
    int RegActEstado = 0;
    string FechaTexto;
    string ProgActIds;


    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      //miMaster.MarcarMenu("mniSubirArchivosRegAct", "mniSubirArchivosRegAct");
      string strParametro = Request.QueryString["IdUsuario"];
      if (!string.IsNullOrWhiteSpace(strParametro))
        intIdUsuario = Convert.ToInt32(strParametro);

      if (!IsPostBack) {

        string str = Request.QueryString["IdDoc"];

        if (!string.IsNullOrWhiteSpace(str)) {
          EnviarDoc(Convert.ToInt32(str));
        }
       
        InicializarFiltros();
        
        object[] arreglo = (object[])TraerParametro(typeof(RegistroActividad));
        ProgActIds = arreglo[0].ToString();
        FechaTexto = arreglo[1].ToString();

        LlenarGrillaDoc(ProgActIds, FechaTexto);
        LlenarGrillaDocSubir(ProgActIds, FechaTexto);
        LlenarGrillaActividad(ProgActIds, FechaTexto);

        IniciaParametros();
        dtgDocs.PageSize = 20;
        dtgDocsSubir.PageSize = 20;

      } else {
        //dttDdls = (DataTable)ViewState["dttDdls"];
        ProgActId = Convert.ToInt32(ViewState["ProgActId"]);
        intIdUsuario = Convert.ToInt32(ViewState["intIdUsuario"]);
        RegActEstado = Convert.ToInt32(ViewState["RegActEstado"]);
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("ProgActId", ProgActId);
      ViewState.Add("intIdUsuario", intIdUsuario);
      ViewState.Add("RegActEstado", RegActEstado);
    }

    

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);
      
      this.SalvaForma = true;

    }

    #endregion   

    #region Actualizar        
       
    private void InsertarDoc(string IdsProgActivDocs, string Ensayo, string IdsProgActiv, string strFecha) {
      string strError = null;
      byte[] byt = FuncGen.FileToByte(Path.Combine(Server.MapPath("."), fluArchivo.FileName), ref strError);
      object[] objParam = new object[] {
        0,
        Convert.ToInt32(IdsProgActivDocs),
        Convert.ToInt32(Ensayo),
        Convert.ToInt32(IdsProgActiv),
        strFecha,
        txtNombreArchivo.Text,
        fluArchivo.FileName,
        byt,
        0
      };

      if (objApp.Ejecutar("ProgramacionActividadRegistroDocIns", objParam)) {
        miMaster.MensajeInformacion(this);
        File.Delete(Path.Combine(Server.MapPath("."), fluArchivo.FileName));

      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }      
    }

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
    
    #endregion

    #region Interfaz        
   
    private void LlenarGrillaDoc(string strIdsProgAct, string strFechas) {
      object[] objParam = new object[] { 0, strIdsProgAct, strFechas };

      DataTable dttTabla = objApp.TraerTabla("ProgramacionActividadDocSel_Grids", objParam, 60);

      if (dttTabla != null) {
        RefrescarGrilla(dtgDocs, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarGrillaActividad(string strIdsProgAct, string strFechas) {
      object[] objParam = new object[] { 0, strIdsProgAct, strFechas };

      DataTable dttTabla = objApp.TraerTabla("ProgramacionActividadSel_Ids", objParam, 60);

      if (dttTabla != null) {
        RefrescarGrilla(dtgPrincipal, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }

    private void LlenarGrillaDocSubir(string strIdsProgAct, string strFechas) {
      object[] objParam = new object[] { 0, strIdsProgAct, strFechas };

      DataTable dttTabla = objApp.TraerTabla("ProgramacionActividadRegistroDocSel_Grids", objParam);

      if (dttTabla != null) {
        RefrescarGrilla(dtgDocsSubir, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
          return;
        }
      }
    }
    
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
    
    protected void btnGuardarDoc_Click(object sender, EventArgs e) { 
      int contador = 0;
      StringBuilder stb = new StringBuilder();
      StringBuilder stb2 = new StringBuilder();
      StringBuilder stb3 = new StringBuilder();
      StringBuilder stb4 = new StringBuilder();
      StringBuilder stb5 = new StringBuilder();

      foreach (GridViewRow row in dtgDocs.Rows) {
        if (row.RowIndex == dtgDocs.SelectedIndex) {
          stb.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[0]); //IdProgramacionActividadDoc
          stb2.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[2]);//IdProgramacionActividad
          stb3.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[3]);//IdProgramacionActividadRegistro
          stb4.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[1]);//FechaTexto
          stb5.AppendFormat("{0}|", dtgDocs.DataKeys[row.RowIndex].Values[4]);//Ensayo
          contador = contador + 1;
        } 
      }

      if (contador > 0) {

        if (stb.Length > 0)
          stb.Remove(stb.Length - 1, 1);

        if (stb2.Length > 0)
          stb2.Remove(stb2.Length - 1, 1);

        if (stb3.Length > 0)
          stb3.Remove(stb3.Length - 1, 1);

        if (stb4.Length > 0)
          stb4.Remove(stb4.Length - 1, 1);

        if (stb5.Length > 0)
          stb5.Remove(stb5.Length - 1, 1);

        InsertarDoc(stb.ToString(), stb5.ToString(), stb2.ToString(), stb4.ToString());
        txtNombreArchivo.Text = null;
        LlenarGrillaDoc(stb2.ToString(), stb4.ToString());
        LlenarGrillaDocSubir(stb2.ToString(), stb4.ToString());
      }
    }

    protected void btnCerrarDoc_Click(object sender, EventArgs e) {
      LlamarFormulario("RegistroActividad.aspx", null);
    }

    protected void fluArchivo_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e) {
      File.WriteAllBytes(Path.Combine(Server.MapPath("."), fluArchivo.FileName), fluArchivo.FileBytes);

    }
    
    protected void btnDescargar_Click(object sender, EventArgs e) {
      foreach (GridViewRow row in dtgDocs.Rows) {
        if (row.RowIndex == dtgDocs.SelectedIndex) {
          int intIdDoc = Convert.ToInt32(dtgDocs.DataKeys[row.RowIndex].Value);
          EnviarDoc(intIdDoc);
        }
      }
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgDocs_RowDataBound(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.DataRow) {
        e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(dtgDocs, "Select$" + e.Row.RowIndex);
        e.Row.ToolTip = "Click to select this row.";
      }
    }

    protected void dtgDocs_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgDocs.SelectedIndex = -1;
    }

    protected void dtgDocs_OnSelectedIndexChanged(object sender, EventArgs e) {
      foreach (GridViewRow row in dtgDocs.Rows) {
        if (row.RowIndex == dtgDocs.SelectedIndex) {          
          row.BackColor = ColorTranslator.FromHtml("#90EE90");
          row.ToolTip = string.Empty;
          txtNombreArchivo.Text = HttpUtility.HtmlDecode( dtgDocs.Rows[row.RowIndex].Cells[1].Text);
        } else {
          row.BackColor = ColorTranslator.FromHtml("#FFFFFF");
          row.ToolTip = "Seleccione este registro";
        }
      }
    }
    
    protected void dtgDocs_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Descargar") {
        foreach (GridViewRow row in dtgDocs.Rows) {
          if (row.RowIndex == dtgDocs.SelectedIndex) {
            int intIdDoc = Convert.ToInt32(dtgDocs.DataKeys[row.RowIndex].Value);
            EnviarDoc(intIdDoc);
          }
        }
      }
    }

    protected void dtgDocsSubir_RowCommand(object sender, GridViewCommandEventArgs e) {
      int intIdDoc = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Eliminar") {
        EliminarDocSubir(intIdDoc);
        LlenarGrillaDocSubir(ProgActIds,FechaTexto);
      } else if (e.CommandName == "Visualizar") {
        EnviarDocSubir(intIdDoc);
      }
    }

    
    #endregion

    #region Persistencia 

    #endregion

    
  }
    
}