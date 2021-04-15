<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="RecepcionCons.aspx.cs" Inherits="WEB.RecepcionCons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Consulta de Productos y Herramientas Ingresados</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Consulta de Recepciones</li>
        </ol>
    </div>

    <script>
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(), 0, 0, 0, 0);
        $(function () {
            $("#<%= txtFechaDesde.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $("#<%= txtFechaHasta.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })

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

                <div class="form-group col-md-6 col-sm-6">
                    <label for="txtNumero">Folio de Recepción</label>
                    <div class="input-group" style="left: 0px; top: 0px">
                        <asp:TextBox ID="txtNumero" runat="server" class="form-control" placeholder="Folio" TextMode="Number" autocomplete="off"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlEstado">Estado</label>
                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Estado"></asp:DropDownList>
                </div>                
                
            </div>

            <div class="row">
            <div class="form-group col-md-4 col-sm-4">
                <label>Fecha Desde</label>

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
            <div class="form-group col-md-4 col-sm-4">
                <label>Fecha Hasta</label>

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
                
                
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlBodega">Bodega</label>
                    <asp:DropDownList ID="ddlBodega" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>                
                
                
                       
        </div>

            <div class="row">

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlUsuarioCrea">Usuario Creación</label>
                    <asp:DropDownList ID="ddlUsuarioCrea" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="usu_usuario"></asp:DropDownList>
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlProducto">Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdProducto" DataTextField="Descripcion"></asp:DropDownList>
                </div>

                
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-success" Text="Nuevo" OnClick="btnNuevo_Click"  />
        </div>

    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Listado de Ingresos</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" OnRowCommand="dtgPrincipal_RowCommand" AllowSorting="True" OnDataBound="dtgPrincipal_DataBound">
                <Columns>                    
                    <asp:BoundField DataField="Numero" HeaderText="Folio" />
                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Estado" HeaderText="Estado" />
                    <asp:BoundField DataField="Bodega" HeaderText="Bodega" />
                    <asp:BoundField DataField="Observacion" HeaderText="Observación" />
                    <asp:BoundField DataField="UsuarioCrea" HeaderText="Usuario Creación" />
                    <asp:BoundField DataField="FechaCrea" HeaderText="Fecha Creación" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="UsuarioMod" HeaderText="Usuario Modificación" />
                    <asp:BoundField DataField="FechaMod" HeaderText="Fecha Modificación" DataFormatString="{0:d}" />
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
</asp:Content>
