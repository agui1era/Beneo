<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarClave.aspx.cs" Inherits="WEB.RecuperarClave" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Login</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="AdminLte/plugins/fontawesome-free/css/all.min.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css"/>
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="AdminLte/plugins/icheck-bootstrap/icheck-bootstrap.min.css"/>
    <!-- Theme style -->
    <link rel="stylesheet" href="AdminLte/dist/css/adminlte.min.css"/>
    <!-- Google Font: Source Sans Pro -->
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet"/>
</head>
<body class="login-page" style="min-height: 402.391px;">
<div class="login-box">
  <div class="login-logo">
    <%--<a href="../../index2.html"><b>Admin</b>LTE</a>--%>
  </div>
  <!-- /.login-logo -->
  <div class="card">
    <div class="card-body login-card-body">
      <p class="login-box-msg">Actualización de Contraseña</p>

      <form runat="server">
          <div class="input-group mb-3">
              <asp:TextBox ID="txtPassword" runat="server" CssClass ="form-control" placeholder="Password" type="password" autopostback="true" OnTextChanged="txtPassword_TextChanged"/>
              <div class="input-group-append">
                  <div class="input-group-text">
                      <span class="fas fa-lock"></span>
                  </div>
              </div>
          </div>
          <div class="input-group mb-3">
              <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" placeholder="Confirmar Password" type="password" autopostback="true" OnTextChanged="txtConfirmPass_TextChanged" />
              <div class="input-group-append">
                  <div class="input-group-text">
                      <span class="fas fa-lock"></span>
                  </div>
              </div>
          </div>
          <div class="row">
              <div class="col-6">
                  <asp:Label ID="lblError" CssClass="alert-danger" runat="server" Text=""></asp:Label>
              </div>
              <!-- /.col -->
              <div class="col-6">
                  <asp:Button ID="btnSubmit" CssClass="btn btn-primary" runat="server" Text="Cambiar Password" OnClick="btnSubmit_Click" />
              </div>
              <!-- /.col -->
          </div>       
      </form>

      <p class="mt-3 mb-1">
        <a href="login.html">Login</a>
      </p>
    </div>
    <!-- /.login-card-body -->
  </div>
</div>
<!-- /.login-box -->

<!-- jQuery -->
<script src="../../plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="../../dist/js/adminlte.min.js"></script>



</body>
</html>
