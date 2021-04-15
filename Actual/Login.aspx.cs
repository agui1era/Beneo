using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using ITD.Web;

namespace WEB {
  public partial class Login : FrmBase {

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    protected void Page_Load(object sender, EventArgs e) {

    }


    protected void btnSubmit_Click(object sender, EventArgs e) {
      if (validar()) {

        ClaseGeneral.RESULTADO_ACCESO resultado = objApp.VerificarAccesoCliente(txtCorreo.Value.ToString(), txtPass.Value.ToString());
        if (resultado == ClaseGeneral.RESULTADO_ACCESO.Ok) {
          lblError.Text = "";
          Response.Redirect("Inicial/Forma.aspx");
        } else {
          lblError.Text = resultado == ClaseGeneral.RESULTADO_ACCESO.ClaveErronea ? "Clave invalida" : resultado == ClaseGeneral.RESULTADO_ACCESO.NoExiste ? "No existe." : "Error desconocido";
        }
      }
    }

    private bool validar() {
      System.Text.StringBuilder stb = new System.Text.StringBuilder();
      if (string.IsNullOrWhiteSpace(txtCorreo.Value.ToString())) {
        stb.AppendLine("Debe ingresar correo");
      }
      if (string.IsNullOrWhiteSpace(txtPass.Value.ToString())) {
        stb.AppendLine("Debe ingresar clave");
      }
      lblError.Text = stb.ToString();
      return string.IsNullOrWhiteSpace(stb.ToString());
    }
  }
}