<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="MovimientoCons.aspx.cs" Inherits="WEB.MovimientoCons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Consulta de Movimientos</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Consulta de Movimientos</li>
        </ol>
    </div>

    <script>
  $(function () {
    $("#<%= dtgPrincipal.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false,
      "searching": false
    });
    
  });
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Filtros</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">
            <div class="row">
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlProducto">Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdProducto" DataTextField="Descripcion"></asp:DropDownList>
                </div>
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlUnidadMedida">Unidad Medida</label>
                    <asp:DropDownList ID="ddlUnidadMedida" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />
            <%--<asp:Button ID="btnNuevo" runat="server" class="btn btn-success" Text="Nuevo" OnClick="btnNuevo_Click"  />--%>
        </div>

    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Lista de Movimientos</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" AllowSorting="True" OnDataBound="dtgPrincipal_DataBound">
                <Columns>                    
                    <asp:BoundField DataField="IdProducto" HeaderText="Código" />
                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                    <asp:BoundField DataField="FechaVcto" HeaderText="Fecha Vcto" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Sigla" HeaderText="Unidad Medida" />                    
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
</asp:Content>
