<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="RecepcionAct.aspx.cs" Inherits="WEB.RecepcionAct" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <%--<link rel="stylesheet" href="../AdminLte/plugins/select2/css/select2.min.css" />--%>

    <script type="text/javascript">
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
        $(function () {
            $("#<%= txtFecha.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $('.select2').select2()

           <%-- $("#<%= dtgActividades.ClientID %>").DataTable({
                "responsive": true,
                "autoWidth": false
            });--%>
        })

        $(function () {
       
            $("#<%= dtgProductos.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false,
              "searching": false
            });
  });

    </script>

    
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Ingreso de Productos y Herramientas</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item"><a href="RecepcionCons.aspx">Consulta de Recepciones</a></li>
            <li class="breadcrumb-item active">Actualización de Recepciones</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card card-default" data-select2-id="42">
        <div class="card-header">
            <h3 class="card-title"></h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
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
                    <label for="txtNumero">Folio de Recepción</label>
                    <asp:TextBox ID="txtNumero" runat="server" class="form-control" placeholder="Número" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtFecha">Fecha</label>
                    <asp:TextBox ID="txtFecha" runat="server" class="form-control" autocomplete="off" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlEstado">Estado</label>
                    <asp:TextBox ID="txtEstado" runat="server" class="form-control" placeholder="Estado" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlBodega">Bodega</label>
                    <asp:DropDownList ID="ddlBodega" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>
            </div>           

            <div class="row">
                <div class="form-group col-md-12 col-sm-12">
                    <label for="txtObservacion">Observación</label>
                    <asp:TextBox ID="txtObservacion" runat="server" class="form-control" placeholder="Observacion" autocomplete="off"></asp:TextBox>
                </div>
            </div>
        </div>
        
        <div class="card-footer">

            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnIngresarDet" runat="server" class="btn btn-primary" Text="Ingresar Detalle" OnClick="btnIngresarDet_Click" Enabled="False" />
            <asp:Button ID="btnConfirmar" runat="server" class="btn btn-warning" Text="Confirmar Ingreso" OnClick="btnConfirmar_Click" />
            <%--<asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />--%>
        </div>

        <!-- /.card-body -->  
    </div>

    
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Detalles de ingreso</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgProductos" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnRowCommand="dtgProductos_RowCommand" OnDataBound="dtgProductos_DataBound" OnRowCreated="dtgProductos_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Descripcion" HeaderText="Producto / Herramienta" />
                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" DataFormatString="{0:#,##0.##}" />     
                    <asp:BoundField DataField="Sigla" HeaderText="Unidad" />
                    <asp:BoundField DataField="FechaVcto" DataFormatString="{0:d}" HeaderText="Fecha Vcto">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>            
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