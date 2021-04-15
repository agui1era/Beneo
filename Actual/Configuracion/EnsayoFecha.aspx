<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="EnsayoFecha.aspx.cs" Inherits="WEB.EnsayoFecha" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $("#<%= txtFechaSiembra.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $('.select2').select2()

            $("#<%= dtgEnsayos.ClientID %>").DataTable({
                "responsive": true,
                "autoWidth": false
            });
        })
    </script>
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">
            <asp:Label ID="lblTitulo" runat="server" Text="Label"></asp:Label></h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item"><a href="Ensayo.aspx">Ensayo</a></li>
            <li class="breadcrumb-item active">Fechas de cosecha</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de Fechas de Siembra</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">

  
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label>Fecha de Siembra</label>

                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="far fa-calendar-alt"></i>
                            </span>
                        </div>
                        <asp:TextBox ID="txtFechaSiembra" runat="server" class="form-control" autocomplete="off" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                    </div>
                    <!-- /.input group -->
                </div>
                
                <div class="form-group col-md-6 col-sm-6">
                    <label for="lstTratamientos">Tratamientos</label>
                    <asp:ListBox ID="lstTratamientos" CssClass="form-control select2" DataValueField="Id" DataTextField="Id" runat="server" SelectionMode="Multiple"></asp:ListBox>
                    <asp:Button ID="btnTodos" CssClass="btn btn-info" runat="server" Text="Seleccionar Todos" OnClick="btnTodos_Click" />
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
            <h3 class="card-title">Consulta de fechas de siembra</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgEnsayos" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnRowCommand="dtgEnsayo_RowCommand" OnDataBound="dtgEnsayos_DataBound" OnRowCreated="dtgEnsayos_RowCreated" OnRowDataBound="dtgEnsayo_RowDataBound">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="FechaSiembra" HeaderText="Fecha de siembra" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Tratamientos" HeaderText="Tratamientos" />
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
