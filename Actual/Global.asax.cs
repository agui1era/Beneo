using ITD.AccDatos;
using ITD.Log;
using ITD.Web;
using System;
using System.Web.Routing;
using WEB.General;
using System.Web.UI.WebControls;
using System.Text;
using System.Globalization;

namespace WEB {
  public class Global : System.Web.HttpApplication {

    public const string ERROR = "ERROR";
    public static CultureInfo Espanol = new CultureInfo("es-CL");

    void Application_Start(object sender, EventArgs e) {
      // Código que se ejecuta al iniciar la aplicación
      RouteConfig.RegisterRoutes(RouteTable.Routes);
      ManejadorLog.InicializarLog("Beneo"); 
      var datos = new AccMsSql(Properties.Settings.Default.CadenaConexion, Properties.Settings.Default.CadenaEncriptada);
      datos.LoguearTodo = true;
      Application.Add("Datos", datos);
      Reporte.VisorReporte = "../General/VisorReporte.aspx";

      Persistencia.Conexion = datos;
      Persistencia.Aplicacion = "Beneo";
      Persistencia.Version = "1.0";

      Persistencia.GuardaEnBD = false;

    }

    void Session_Start(object sender, EventArgs e) {
      var datos = (AccMsSql)Application["Datos"];
      if (Properties.Settings.Default.Debug) datos.LimpiarComandos();
      var objApp = new ClaseGeneral(datos);
      Session.Add(FrmBase.LlaveGen, objApp);
    }

    public static string ObtenerSeleccionados(ListBox lst) {
      StringBuilder stb = new StringBuilder();

      foreach (int item in lst.GetSelectedIndices()) {
        stb.Append(lst.Items[item].Value).Append('|');
      }


      return stb.ToString();
    }


    public static Tuple<DateTime, DateTime> ObtenerFechas(TextBox txtRangoFecha) {
      if (string.IsNullOrWhiteSpace(txtRangoFecha.Text))
        return null;
      string[] strRango = txtRangoFecha.Text.Split('-');

      DateTime dtDesde, dtHasta;

      string[] strSplit = strRango[0].Split('/');
      dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));
      strSplit = strRango[1].Split('/');
      dtHasta = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));


      return new Tuple<DateTime, DateTime>(dtDesde, dtHasta);
    }

    public static DateTime? ObtenerFechaPura(string strFecha) {
      if (string.IsNullOrWhiteSpace(strFecha))
        return null;


      string[] strSplit = strFecha.Split('/');
      DateTime dtDesde = new DateTime(Convert.ToInt32(strSplit[2]), Convert.ToInt32(strSplit[1]), Convert.ToInt32(strSplit[0]));

      return dtDesde;
    }

    public static decimal? convertiraNumero(string text) {
      if (string.IsNullOrWhiteSpace(text))
        return null;


      text = text.Replace(".", ",");
      decimal numero = 0;
      if (string.IsNullOrWhiteSpace(text)) {
        return numero;
      } else {
        if (decimal.TryParse(text, out numero)) {
          return numero;
        } else {
          return numero;
        }
      }

    }

  }
}