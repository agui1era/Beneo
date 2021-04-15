<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="EnsayoClonar.aspx.cs" Inherits="WEB.EnsayoClonar" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
       <div class="col-sm-6">
        <h1 class="m-0 text-dark">Ensayo</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Ensayo</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- general form elements -->

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Clonar Ensayos</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">           
            
    <div class="alert alert-danger">
        <strong>Se requiere cambiar el código del ensayo.</strong>
    </div>
    
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCodigoClonar">Código Ensayo</label>
                    <asp:TextBox ID="txtCodigoClonar" runat="server" class="form-control" placeholder="Codigo" autocomplete="off"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtNombreClonar">Nombre Ensayo</label>
                    <asp:TextBox ID="txtNombreClonar" runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6" id="grpFechas" runat="server">
                    <label for="txtFechasClonar">Fechas de siembra</label>
                    <asp:Button ID="btnFechasSiembras" CssClass="btn btn-block btn-primary" runat="server" Text="Fechas Siembra" OnClick="btnFechasSiembras_Click" />
                </div>
            </div>
        </div>
        <div class="card-footer">
            <asp:Button ID="btnClonar" runat="server" Text="Clonar" CssClass="btn btn-primary" OnClick="btnClonar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="btnCancelar_Click" />            
        </div>
    </div>   
</asp:Content>
