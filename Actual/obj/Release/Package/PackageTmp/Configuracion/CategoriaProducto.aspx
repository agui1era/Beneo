<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="CategoriaProducto.aspx.cs" Inherits="WEB.CategoriaProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <div class="col-sm-6">
        <h1 class="m-0 text-dark">Categoria de Producto</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Categoria</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Categoria</h3>
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
                    <label for="txtCodigo">Código</label>
                    <asp:TextBox ID="txtCodigo" runat="server" class="form-control" placeholder="Codigo" autocomplete="off"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCategoria">Categoria</label>
                    <asp:TextBox ID="txtCategoria" runat="server" class="form-control" placeholder="Categoria" autocomplete="off"></asp:TextBox>
                </div>
            </div>
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
            <h3 class="card-title">Consulta</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgCategoria" CssClass="table table-bordered table-striped" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgCategoria_PageIndexChanging" OnRowCommand="dtgCategoria_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                    <asp:BoundField DataField="Categoria" HeaderText="Categoria" />
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
    </div>

</asp:Content>

