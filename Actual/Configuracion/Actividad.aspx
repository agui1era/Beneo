<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Actividad.aspx.cs" Inherits="WEB.Actividad" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Actividad</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Actividad</li>
        </ol>
    </div>
    
    <script>
  $(function () {
    $("#<%= dtgActividad.ClientID %>").DataTable({
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
    <!-- general form elements -->
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de Actividades</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtNombre">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                    <asp:DropDownList ID="ddlActividadExiste" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Nombre" DataTextField="Nombre"></asp:DropDownList>
                </div>
                
                <div class="col-md-1 col-sm-1">
                        <asp:Button ID="btnNuevaAct" runat="server" class="btn btn-default" Text="Nuevo" OnClick="btnNuevaAct_Click"/>
              
                </div>
            </div>
             <div class="row">
                    <div class="form-group col-md-6 col-sm-6">
                            <label for="lstProductos">Categoria Productos</label>
                            <asp:ListBox ID="lstCategoria" CssClass="form-control select2" DataValueField="Id" DataTextField="Categoria" runat="server" SelectionMode="Multiple"></asp:ListBox>
                            <%--<asp:Button ID="btnTodos" CssClass="btn btn-info" runat="server" Text="Seleccionar Todos" OnClick="btnTodos_Click" />--%>
                    </div>
                    <div class="form-group col-md-6 col-sm-6">
                            <label for="lstHerramientas">Categoria Herramientas</label>
                            <asp:ListBox ID="lstHerramientas" CssClass="form-control select2" DataValueField="Id" DataTextField="Categoria" runat="server" SelectionMode="Multiple"></asp:ListBox>
                    </div>
                  </div>

            <div class="row">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="chkActivo" runat="server" />
                    <%--<asp:CheckBox ID="chkActivo" runat="server" class="form-check-input" />--%>
                    <label for="chkActivo" class="form-check-label">Activo</label>
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
            <h3 class="card-title">Consulta de Actividades</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgActividad" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgActividad_PageIndexChanging" OnRowCommand="dtgActividad_RowCommand" OnDataBound="dtgActividad_DataBound" OnRowCreated="dtgActividad_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
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
    <!-- /.card -->

    <!-- /.card -->
    <!-- /.container-fluid -->
    <%--<!-- Modal Confimaciones Eliminar -->
    <div class="modal" id="ConfirmacionEliminacion" tabindex="-1" role="dialog" aria-labelledby="ConfirmacionEliminacionLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmación Eliminación</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Esta realizando eliminacion de registro. ¿Confirma?</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnModalEliminar" runat="server" Text="Confirmar" CssClass="btn btn-primary" OnClick="btnModalEliminar_Click" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>--%>
</asp:Content>
