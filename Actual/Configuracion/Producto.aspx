<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Producto.aspx.cs" Inherits="WEB.Producto" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Producto</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Producto</li>
        </ol>
    </div>
    
    <script>
    
        $(function () {
       
            $("#<%= dtgProductos.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false,
              "searching": false
            });
  });
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de Productos</h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <div class="row">
                <div class="form-group col-md-4 col-sm-4">
                    <label for="txtCodigo">Código de Barra</label>
                    <asp:TextBox ID="txtCodigo" name="txtCodigo" runat="server" class="form-control" placeholde="Código de Barra" autocomplete="off"></asp:TextBox>
                </div>
                <div class="form-group col-md-7 col-sm-7">
                    <label for="txtNombre">Nombre</label>
                    <asp:TextBox ID="txtNombre" name="txtNombre" runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                    <asp:DropDownList ID="ddlProdExiste" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Descripcion"></asp:DropDownList>

                </div>
                <div class="col-md-1 col-sm-1">
                        <asp:Button ID="btnNuevoProd" runat="server" class="btn btn-default" Text="Nuevo" OnClick="btnNuevoProd_Click" />
              
                </div>
            </div>
            <%--<div class="row">
                
            </div>--%>
            <div class="row">
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlCategoria">Categoria</label>
                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Categoria"></asp:DropDownList>
                </div>
        
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlUM">Unidad de Medida</label>
                    <asp:DropDownList ID="ddlUM" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Sigla"></asp:DropDownList>
                </div>
                <div class="form-group col-md-4 col-sm-4">
                    <label for="txtLimite">Límite Stock</label>
                    <asp:TextBox ID="txtLimite" runat="server" class="form-control" placeholder="Límite Stock" autocomplete="off"></asp:TextBox>

                </div>
            </div>




            <div class="row">

                  <div class="form-group col-md-4 col-sm-4">
                    <label for="txtLimite">Ingrediente Activo</label>
                    <asp:TextBox ID="txtIngredienteActivo" runat="server" class="form-control" placeholder="Ingrediente Activo" autocomplete="off" ></asp:TextBox>
                    <asp:DropDownList ID="ddlIngredienteActivo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IngredienteActivo" DataTextField="IngredienteActivo"></asp:DropDownList>
                      
                </div>
                <div class="col-md-1 col-sm-1">
                        <asp:Button ID="btnIngredienteActivo" runat="server" class="btn btn-default" Text="Nuevo" OnClick="btnIngredienteActivo_Click" />
              
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.card-body -->
        <div class="card-footer">

            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Productos</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgProductos" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgProductos_PageIndexChanging" OnRowCommand="dtgProductos_RowCommand" OnDataBound="dtgProductos_DataBound" OnRowCreated="dtgProductos_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Codigo" HeaderText="Codigo" />
                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                    <asp:BoundField DataField="Sigla" HeaderText="UM" />
                    <asp:BoundField DataField="Categoria" HeaderText="Categoria" />
                    <asp:BoundField DataField="Limite" HeaderText="Límite" DataFormatString="{0:#,##0.##}" >
                    <HeaderStyle HorizontalAlign="Right" />
                    <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="IngredienteActivo" HeaderText="Ing. Activo" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
</asp:Content>
