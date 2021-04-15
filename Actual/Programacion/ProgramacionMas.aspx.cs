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
  public partial class ProgramacionMas : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniProgramacionMas", "mniProgra");
      if (!IsPostBack) {
        IniciarParametros();
        rbtSemana_CheckedChanged(null, null);
        rbtFechaCosecha.Enabled = false;
        txtDiasCosecha.Enabled = false;
        //intId = Convert.ToInt32(TraerParametro(typeof(ProgramacionCons)));
        //LlenarControles();
      } else {
        //intId = Convert.ToInt32(ViewState["intId"]);
        //ActId = Convert.ToInt32(ViewState["ActId"]);
      }
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      LlenarDdls();
      
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      var tupla = Global.ObtenerFechas(txtRangoFecha);
      decimal? decValorDosis = Global.convertiraNumero(txtDosis.Text);
      decimal? decValorTotalDosis = Global.convertiraNumero(txtDosisTotal.Text);
      decimal? decValorSuperficie = Global.convertiraNumero(txtValorSuperficie.Text);
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        ddlTemporada.SelectedValue,
        ddlLugar.SelectedValue,
        Global.ObtenerSeleccionados(lstEnsayo),
         rbtSemana.Checked ? (DateTime?)tupla.Item1 : null,
         rbtSemana.Checked ? (DateTime?)tupla.Item2 : null,
        rbtSemana.Checked ? Global.ObtenerSeleccionados(lstDia) : null,
        ddlActividad.Text,
        ddlPrioridad.SelectedValue,
        txtObservaciones.Text,
        objApp.InfoUsr.IdUsuario,
        rbtFechaCosecha.Checked ? txtDiasCosecha.Text :"0" ,
        ObtenerMarcados(dtgProductos, 0),
        ObtenerXMLHerramienta(),
        decValorDosis,
        !decValorDosis.HasValue ? null : ddlUM.SelectedValue,
        !decValorDosis.HasValue ? null : ddlUMValor.SelectedValue,
        !decValorDosis.HasValue ? null : ddlSuperficieObj.SelectedValue,
        TextoDosis(),
        !decValorDosis.HasValue ? null : decValorTotalDosis,
        !decValorDosis.HasValue ? null : decValorSuperficie
      };

      if (objApp.Ejecutar("ProgramacionMas_Ins", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarProductos();
        LlenarHerramientas();
        //CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz        

    #region Ddls

    private void LlenarDdls() {
      LlenarddlTemporada(false);
      LlenarddlDia(false);
      LlenarddlActividad(false, "");
      LlenarddlPrioridad(false);
      LlenarddlUMBase(false);

      DataTable dtTrat = new DataTable();
      dtTrat.Columns.Add("Nombre");

      dtTrat.Rows.Add("Todos");

      ddlTratamiento.DataSource = dtTrat.DefaultView;
      ddlTratamiento.DataBind();

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
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
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


      lstEnsayo.DataSource = new DataView(dt, string.Format("IdLugar={0}", intIdLugar), "Codigo", DataViewRowState.OriginalRows);
      lstEnsayo.DataBind();


      //ddlPrueba.DataSource = new DataView(dt, "Id > 0", "Nombre", DataViewRowState.OriginalRows);
      //ddlPrueba.DataBind();
      return true;
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
      strNuevo = strNuevo.ToUpper();
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

    private bool LlenarddlUMBase(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheUnidadMedida");

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

      ddlUM.DataSource = new DataView(dt, "", "Sigla", DataViewRowState.OriginalRows);
      ddlUM.DataBind();

      ddlUMValor.DataSource = new DataView(dt, "", "Sigla", DataViewRowState.OriginalRows);
      ddlUMValor.DataBind();

      ddlSuperficieObj.DataSource = new DataView(dt, "", "Sigla", DataViewRowState.OriginalRows);
      ddlSuperficieObj.DataBind();

      return true;
    }

    #endregion

    private void Previsualizar() {
      var tupla = Global.ObtenerFechas(txtRangoFecha);
      //var res = ObtenerFechas();
      object[] objParam = new object[] {
        ddlTemporada.SelectedValue,
        ddlLugar.SelectedValue,
        Global.ObtenerSeleccionados(lstEnsayo),
         rbtSemana.Checked ? (DateTime?)tupla.Item1 : null,
         rbtSemana.Checked ? (DateTime?)tupla.Item2 : null,
        rbtSemana.Checked ? Global.ObtenerSeleccionados(lstDia) : null,
        ddlActividad.Text,
        ddlPrioridad.SelectedValue,
        txtObservaciones.Text,
        objApp.InfoUsr.IdUsuario,
        rbtFechaCosecha.Checked ? txtDiasCosecha.Text :"0"
      };

      DataTable dt = objApp.TraerTabla("ProgramacionMas_Val", objParam);

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgProgramacion, dt.DefaultView, false);
        string script3 = "<script type=text/javascript> $(function () {$('#modal-previsualizar').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      }

    }
    
    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (rbtSemana.Checked) {
        var tupla = Global.ObtenerFechas(txtRangoFecha);
        if ((tupla.Item2 - tupla.Item1 ).TotalDays != 6)
          stbError.Append("El rango de fecha debe ser de 6 días <br>");
        else if (tupla.Item1.DayOfWeek != DayOfWeek.Monday)
          stbError.Append("El rango de fecha debe comenzar con el día lunes <br>");
      }

      if (!string.IsNullOrWhiteSpace(txtDosis.Text) && (string.IsNullOrWhiteSpace(ddlUM.SelectedValue) || string.IsNullOrWhiteSpace(ddlUMValor.SelectedValue)))
        stbError.Append("El rango de fecha debe comenzar con el día lunes <br>");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: <br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
 

      return true;
    }

    private void LlenarProductos() {
      DataTable dt = objApp.TraerTabla("ProgramacionSel_Productos", new object[] { ddlLugar.SelectedValue });

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgProductos, dt.DefaultView, false);
      }

    }

    private void LlenarHerramientas() {
      DataTable dt = objApp.TraerTabla("ProgramacionSel_Herramienta", new object[] { ddlLugar.SelectedValue });

      if (dt == null && objApp.UltimoError != null) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      } else {
        RefrescarGrilla(dtgHerramientas, dt.DefaultView, false);
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
          stb.AppendFormat("<v Id=\"{0}\" Cantidad=\"{1}\" />", dtgHerramientas.DataKeys[item.RowIndex].Value, ((TextBox)item.Cells[dtgHerramientas.Columns.Count - 1].Controls[1]).Text.Replace(",","."));
      }
      
      return stb.ToString();
    }

    private string TextoDosis() {
      string strValor = null;

      if (string.IsNullOrWhiteSpace(txtDosis.Text))
        return null;

      strValor = string.Format("{0} {1}/{2}", txtDosis.Text, ddlUM.SelectedItem.Text, ddlUMValor.SelectedItem.Text);

      return strValor;
    }

    private decimal CalculoValorDosisTotal() {
      decimal decValor = 0;
      int intUM = Convert.ToInt32(ddlUMValor.SelectedValue);
      int intUMSuperficie = Convert.ToInt32(ddlSuperficieObj.SelectedValue);
      decimal? decValorSuperficie = Global.convertiraNumero(txtValorSuperficie.Text);

      DataSet dts = objApp.TraerDataset("ProgramacionTomarUM", new object[] { intUM, intUMSuperficie });

      if (dts != null) {
        decimal decFactorUM = Convert.ToDecimal(dts.Tables[0].Rows[0]["Factor"]);
        decimal decFactorUMSuperficie = Convert.ToDecimal(dts.Tables[1].Rows[0]["Factor"]);

        decValor = (decFactorUMSuperficie / decFactorUM) * decValorSuperficie.Value;

      }


      return decValor;
    }

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void ddlTemporada_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));

      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));

    }

    protected void ddlLugar_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
      LlenarProductos();
      LlenarHerramientas();
    }

    protected void lstEnsayo_SelectedIndexChanged(object sender, EventArgs e) {
      if (lstEnsayo.SelectedIndex > -1) {
        rbtFechaCosecha.Enabled = true;
        txtDiasCosecha.Enabled = true;
      }else {
        rbtFechaCosecha.Enabled = false;
        txtDiasCosecha.Enabled = false;
      }

    }

    protected void btnAgregar_Click(object sender, EventArgs e) {
      if(Validar())
        Previsualizar();
    }

    protected void btnNuevaActividad_Click(object sender, EventArgs e) {
      LlenarddlActividad(false, txtNuevaActividad.Text);
    }

    protected void btnConfirmar_Click(object sender, EventArgs e) {
      Insertar();
    }

    protected void rbtSemana_CheckedChanged(object sender, EventArgs e) {

      txtRangoFecha.ReadOnly = !rbtSemana.Checked;

      foreach (ListItem item in lstDia.Items) {
        item.Enabled = rbtSemana.Checked;
      }

      txtDiasCosecha.ReadOnly = !rbtFechaCosecha.Checked;
    }

    protected void ddlSuperficieObj_SelectedIndexChanged(object sender, EventArgs e) {
      decimal decDosisTotal = CalculoValorDosisTotal();
    }

    #endregion

    #region Eventos de Grillas

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

  }
}