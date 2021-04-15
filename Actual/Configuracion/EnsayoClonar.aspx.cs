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
using System.Drawing;
using System.Globalization;

namespace WEB {
  public partial class EnsayoClonar : FrmBase {

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
    int intTemporada;
    int intEspecie;
    int intResponsable;
    Boolean chkActivo;
    int intCantTratamiento;
    int intCantRepeticion;
    int intCantCosechas;
    int intLugar;

    string strCodigoEnsayo;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      //miMaster.MarcarMenu("mniEnsayoClon", "mniConf");

      if (!IsPostBack) {

        object objParam = TraerParametro(typeof(Ensayo));
        if (objParam != null)
          IdEnsayo = Convert.ToInt32(objParam);

        objParam = TraerParametro(typeof(EnsayoFechaClon));
        if (objParam != null)
          IdEnsayo = Convert.ToInt32(objParam);

        LlenarControles();

        IniciarParametros();

      } else {
        IdEnsayo = (int)ViewState["IdEnsayo"];
        IdEnsayoRel = (int)ViewState["IdEnsayoRel"];
        intTemporada = (int)ViewState["intTemporada"];
        intEspecie = (int)ViewState["intEspecie"];
        intResponsable = (int)ViewState["intResponsable"];
        chkActivo = (bool)ViewState["chkActivo"];
        intCantTratamiento = (int)ViewState["intCantTratamiento"];
        intCantRepeticion = (int)ViewState["intCantRepeticion"];
        intCantCosechas = (int)ViewState["intCantCosechas"];
        intLugar = (int)ViewState["intLugar"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdEnsayo", IdEnsayo);
      ViewState.Add("IdEnsayoRel", IdEnsayoRel);
      ViewState.Add("intTemporada", intTemporada);
      ViewState.Add("intEspecie", intEspecie);
      ViewState.Add("intResponsable", intResponsable);
      ViewState.Add("chkActivo", chkActivo);
      ViewState.Add("intCantTratamiento", intCantTratamiento);
      ViewState.Add("intCantRepeticion", intCantRepeticion);
      ViewState.Add("intCantCosechas", intCantCosechas);
      ViewState.Add("intLugar", intLugar);
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);
    }

    #endregion

    #region Actualizar        
    
    private void ClonarEnsayo() {

      object[] objParam = new object[] {
        0,
        IdEnsayo,
        intTemporada,
        intEspecie,
        txtCodigoClonar.Text,
        txtNombreClonar.Text,
        intResponsable,
        chkActivo,
        intCantTratamiento,
        intCantRepeticion,
        intCantCosechas,
        objApp.InfoUsr.IdUsuario,
        intLugar
      };

      if (objApp.Ejecutar("EnsayoClonarIns", objParam)) {
        IdEnsayo = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        LlamarFormulario("Ensayo", IdEnsayo);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    
    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Ensayo"))
        return "Ya existe el código para la temporada seleccionada. Se requiere cambiar el código de Ensayo";

      if (error.Mensaje.Contains("IX_Ensayo_1"))
        return "Ya existe el ensayo para la temporada seleccionada. Se requiere cambiar el código de Ensayo";

      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz        

    private void LimpiarControles() {
      txtCodigoClonar.Text = null;
      txtNombreClonar.Text = null;
      IdEnsayo = 0;
    }

    

    private void LlenarControles() {

      DataSet dts = objApp.TraerDataset("EnsayoSel_Id", new object[] { IdEnsayo.ToString() });

      if (dts != null && dts.Tables[0].Rows.Count > 0) {
        DataRow dtr = dts.Tables[0].Rows[0];

        IdEnsayo = (int)dtr["Id"];
        strCodigoEnsayo = dtr["Codigo"].ToString();
        txtCodigoClonar.Text = dtr["Codigo"].ToString();
        txtNombreClonar.Text = dtr["Nombre"].ToString();
        grpFechas.Visible = true;
        intTemporada = (int)dtr["IdTemporada"];
        intEspecie = (int)dtr["IdEspecie"];
        intResponsable = (int)dtr["IdResponsable"];
        chkActivo = Convert.ToBoolean(dtr["Activo"]);
        intCantTratamiento = (int)dtr["CantTratamiento"];
        intCantRepeticion = (int)dtr["CantRepeticion"];
        intCantCosechas = (int)dtr["CantCosechas"];
        intLugar = (int)dtr["IdLugar"];

        //btnFechasSiembras.Text = string.Format("{0} Fecha(s)", dtr["CantFechasEnsayo"]);
      }
    }
          
    #endregion

    #region Acciones
    
    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles
           
    protected void btnFechasSiembras_Click(object sender, EventArgs e) {
      LlamarFormulario("EnsayoFechaClon", IdEnsayo);      
    }

    protected void btnClonar_Click(object sender, EventArgs e) {
      if(txtCodigoClonar.Text == strCodigoEnsayo )
        miMaster.MensajeError(this, Global.ERROR, "Se requiere cambiar el código de Ensayo");
      else
        ClonarEnsayo();
    }

    protected void btnCancelar_Click(object sender, EventArgs e) {
      LlamarFormulario("Ensayo", IdEnsayo);
    }
    #endregion

    #region Eventos de Grillas

    #endregion

    #region Persistencia 

    #endregion


  }
}