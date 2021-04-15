<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Configuracion.aspx.cs" Inherits="WEB.Configuracion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Configuración</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Configuración</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- general form elements -->
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Configuración</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="form-group" hidden="hidden">
                <label for="txtId">Id</label>
                <asp:TextBox ID="txtId" runat="server" class="form-control" placeholder="Id"></asp:TextBox>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtServidor">Servidor SMTP</label>
                    <asp:TextBox ID="txtServidor" runat="server" class="form-control" placeholder="Servidor SMTP"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtPuerto">Puerto SMTP</label>
                    <asp:TextBox ID="txtPuerto" runat="server" class="form-control" placeholder="Puerto SMTP"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtUsuario">Usuario SMTP</label>
                    <asp:TextBox ID="txtUsuario" runat="server" class="form-control" placeholder="Usuario SMTP"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtClave">Clave</label>
                    <asp:TextBox ID="txtClave" runat="server" class="form-control" placeholder="Clave"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="chkSSL" runat="server" />
                    <%--<asp:CheckBox ID="chkActivo" runat="server" class="form-check-input" />--%>
                    <label for="chkSSL" class="form-check-label">SSL</label>
                </div>
            </div>

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnActualizar" runat="server" class="btn btn-warning" Text="Actualizar" OnClick="btnActualizar_Click" />
        </div>

    </div>
    
</asp:Content>
