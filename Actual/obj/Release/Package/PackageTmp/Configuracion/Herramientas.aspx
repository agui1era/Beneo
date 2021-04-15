<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Herramientas.aspx.cs" Inherits="WEB.Herramientas" %>
    <asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
     <div class="col-sm-6">
        <h1 class="m-0 text-dark">Herramientas</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Herramientas</li>
        </ol>
    </div>
        
    <script>
  $(function () {
    $("#<%= dtgHerramientas.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false
    });
    //$('#example2').DataTable({
    //  "paging": true,
    //  "lengthChange": false,
    //  "searching": false,
    //  "ordering": true,
    //  "info": true,
    //  "autoWidth": false,
    //  "responsive": true,
    //});
  });
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Herramienta</h3>
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
                <div class="form-group col-md-5 col-sm-5">
                    <label for="txtHerramienta">Nombre</label>
                    <asp:TextBox ID="txtHerramienta" runat="server" class="form-control" placeholder="Nombre Herramienta" autocomplete="off"></asp:TextBox>
                    <asp:DropDownList ID="ddlHerramientaExiste" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Nombre" DataTextField="Nombre"></asp:DropDownList>
                </div>
                <div class="col-md-1 col-sm-1">
                        <asp:Button ID="btnNuevaHerr" runat="server" class="btn btn-default" Text="Nuevo" OnClick="btnNuevaHerr_Click"/>
              
                </div>
            </div>
            <div class="row">
                    <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlCategoria">Categoria</label>
                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Categoria"></asp:DropDownList>
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
            <asp:GridView ID="dtgHerramientas" CssClass="table table-bordered table-striped" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgHerramientas_PageIndexChanging" OnRowCommand="dtgHerramientas_RowCommand" OnDataBound="dtgHerramientas_DataBound" OnRowCreated="dtgHerramientas_RowCreated"> 
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
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
