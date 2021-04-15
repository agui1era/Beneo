<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Stock.aspx.cs" Inherits="WEB.Inventario.Stock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Stock</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inventario</a></li>
            <li class="breadcrumb-item active">Stock</li>
        </ol>
    </div>
    
    <script>
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
        $(function () {
            $("#<%= txtFechaDesde.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $("#<%= txtFechaHasta.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })

            $("#<%= dtgStock.ClientID %>").DataTable({
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

                <div class="form-group col-md-6 col-sm-6">
                    <label>Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdProducto" DataTextField="Descripcion"></asp:DropDownList>
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label>Bodega</label>
                    <asp:DropDownList ID="ddlBodega" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>

            </div>

            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label>Fecha Vcto Desde</label>

                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="far fa-calendar-alt"></i>
                            </span>
                        </div>
                        <asp:TextBox ID="txtFechaDesde" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                    </div>
                    <!-- /.input group -->
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label>Fecha Vcto Hasta</label>

                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="far fa-calendar-alt"></i>
                            </span>
                        </div>
                        <asp:TextBox ID="txtFechaHasta" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                    </div>
                    <!-- /.input group -->
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
            <h3 class="card-title">Existencia</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgStock" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgStock_PageIndexChanging" OnRowCommand="dtgStock_RowCommand" OnDataBound="dtgStock_DataBound" OnRowCreated="dtgStock_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                    <asp:BoundField DataField="Descripcion" HeaderText="Producto / Herramienta" />
                    <asp:BoundField DataField="Cantidad" HeaderText="Stock" />
                    <asp:BoundField DataField="FechaVcto" HeaderText="Fecha Vcto" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="IdBodega" HeaderText="Id Bodega" Visible="false" />
                    <asp:BoundField DataField="Bodega" HeaderText="Bodega" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Mover" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
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
    
    <div class="modal fade" id="modal-Futura" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Actividades Futuras</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <asp:HiddenField ID="hdfIdSel" runat="server" />
                        <div class="form-group col-md-9 col-sm-9">
                            <label for="ddlBodega">Bodega</label>
                            <asp:DropDownList ID="ddlBodegaCambio" runat="server" Width="100%" CssClass="form-control select2" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>

                        </div>

                        <div class="form-group col-md-3 col-sm-3">
                            <label for="txtCantidad">Cantidad</label>
                            <asp:TextBox ID="txtCantidad" runat="server" class="form-control" placeholder="Cantidad"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                        <asp:Button ID="btnGuardarModalCancelar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardarModalCancelar_Click" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
            <!-- /.modal-content -->
        <!-- /.modal-dialog -->
    </div>
    
</asp:Content>
