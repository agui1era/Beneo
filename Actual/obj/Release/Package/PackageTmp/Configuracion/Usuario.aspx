<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Usuario.aspx.cs" Inherits="WEB.Usuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Usuarios</h1>
    </div>
    <script>
        $(function () {
            $("#<%= txtCelular.ClientID %>").inputmask('(999) 9999-9999', { 'placeholder': '(999) 9999-9999' })
        })
        
    $("#<%= dtgUsuarios.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false
    });

    </script>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Usuarios</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- general form elements -->
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de usuario</h3>
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
                    <label for="txtNombre">Nombre Completo*</label>
                    <asp:TextBox ID="txtNombre" runat="server" class="form-control" placeholder="Nombre"></asp:TextBox>
                </div>
            <%--</div>
            <div class="row">--%>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtUsario">Sigla Usuario*</label>
                    <asp:TextBox ID="txtUsuario" runat="server" class="form-control" placeholder="Sigla Usuario"></asp:TextBox>
                </div>
                <%--<div class="form-group col-md-6 col-sm-6">
                     <label for="ddlPerfil">Perfil</label>
                    <asp:DropDownList ID="ddlPerfil" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Perfil"></asp:DropDownList>
                </div>--%>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlTipo">Tipo*</label>
                    <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Tipo"></asp:DropDownList>                    
                </div> 
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtEmail">Correo electronico*</label>
                    <asp:TextBox ID="txtEmail" class="form-control" runat="server" placeholder="Email"></asp:TextBox>
                </div>                  
            </div>     
            <div class="row">
                <%--<div class="form-group col-md-6 col-sm-6">
                    <label for="txtFono">Teléfono</label>
                    <asp:TextBox ID="txtFono" class="form-control" runat="server" placeholder="Teléfono" data-inputmask="mask: (999) 9999-9999" data-mask im-insert="true" ></asp:TextBox>
                </div>   --%>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCelular">Celular</label>
                    <asp:TextBox ID="txtCelular" class="form-control" runat="server" data-inputmask-alias="phone" data-inputmask-inputformat="(999) 9999-9999" data-mask="datemask" im-insert="false" autocomplete="off"></asp:TextBox>
                </div> 
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtObservaciones">Observaciones</label>
                    <asp:TextBox ID="txtObservaciones" runat="server" class="form-control" placeholder="Observaciones"></asp:TextBox>
                </div>   
            </div>                                     
            <div class="row">
                <div class="form-check col-md-6 col-sm-6">                    
                    <input type="checkbox" class="form-check-input" id="chkAdministrador" runat="server" />
                    <label for="chkAdministrador" class="form-check-label">Administrador</label>                    
                </div>                
                <div class="form-check col-md-6 col-sm-6">                    
                    <input type="checkbox" class="form-check-input" id="chkActivo" runat="server" />
                    <label for="chkActivo" class="form-check-label">Activo</label>                    
                </div>
            </div>                        
        </div>
        <!-- /.card-body -->

        <div class="card-footer">
            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
            <asp:Button ID="btnResetear" runat="server" class="btn btn-info" Text="Resetear Contraseña" OnClick="btnResetear_Click" />
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Consulta</h3>
        </div>
        <!-- /.card-header -->       
        <div class="card-body">
            <asp:GridView ID="dtgUsuarios" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgUsuarios_PageIndexChanging" OnRowCommand="dtgUsuarios_RowCommand" OnDataBound="dtgUsuarios_DataBound" OnRowCreated="dtgUsuarios_RowCreated">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <%--<asp:BoundField DataField="rut_empleado" HeaderText="Rut" />--%>
                    <asp:BoundField DataField="Usuario" HeaderText="Usuario" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />          
                    <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->

    <!-- /.card -->

</asp:Content>
