using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ITD.Web;

namespace WEB {
  public partial class VisorReporte : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {
      var objRep = (Reporte)Session[Reporte.LlaveReporte];
      if (objRep != null) {
        Session.Remove(Reporte.LlaveReporte);
        objRep.MostrarReporte(this);
      }
    }
  }
}