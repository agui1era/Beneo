<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="RecepcionDetAct.aspx.cs" Inherits="WEB.RecepcionDetAct" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <%--<link rel="stylesheet" href="../AdminLte/plugins/select2/css/select2.min.css" />--%>
 <script type="text/javascript">
        var nowDate = new Date();
        var today = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate(),0,0,0,0);
        $(function () {
            $("#<%= txtFechaVcto.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $('.select2').select2()
        })

       
     
        $(function () {
       
            $("#<%= dtgPrincipal.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false,
              "searching": false
            });
        });


    </script>

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Recepción</h1>
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
            <h3 class="card-title">Detalle de Recepciones</h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        <!-- /.card-header -->

        <!-- form start -->
        <div class="card-body">
            <div class="form-group" hidden="hidden">
                <label for="txtIdRecepcion">IdRecepcion</label>
                <asp:TextBox ID="txtId" runat="server" class="form-control" placeholder="IdRecepcion"></asp:TextBox>
            </div>

            <div class="row">
                <div class="form-group col-md-3 col-sm-3">
                        <div class="form-check">
                            <asp:RadioButton ID="rbtProducto" CssClass="form-check-input" runat="server" AutoPostBack="True" OnCheckedChanged="rbtHerramienta_CheckedChanged" GroupName="1"  />
                          <%--<input class="form-check-input" type="radio" name="rbtProducto" checked="true" runat="server" id="rbtProducto">--%>
                          <label class="form-check-label">Producto</label>
                        </div>                           
                </div>
                 <div class="form-group col-md-3 col-sm-3">
                        <div class="form-check">
                            <asp:RadioButton ID="rbtHerramienta" CssClass="form-check-input" runat="server" AutoPostBack="True" OnCheckedChanged="rbtHerramienta_CheckedChanged" GroupName="1" />
                          <%--<input class="form-check-input" type="radio" name="rbtHerramienta" checked="" runat="server" id="rbtHerramienta">--%>
                          <label class="form-check-label">Herramienta</label>
                        </div>                           
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label for="ddlProducto" runat="server" id="lblProducto">Producto</label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdProducto" DataTextField="Descripcion" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                    <asp:DropDownList ID="ddlHerramienta" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdHerramienta" DataTextField="Nombre" Visible="False" ></asp:DropDownList>
                </div>
                 <div class="form-group col-md-6 col-sm-6">
                    <label for="txtUM">Unidad</label>
                    <asp:TextBox ID="txtUM" runat="server" class="form-control" autocomplete="off" readOnly="true"></asp:TextBox>
                </div>
                
            </div>
             <div class="row">
                 
                 <div class="form-group col-md-6 col-sm-6">
                    <label for="txtFechaVcto">Fecha Vencimiento</label>
                    <asp:TextBox ID="txtFechaVcto" runat="server" class="form-control" autocomplete="off" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false"></asp:TextBox>
                </div>
                 <div class="form-group col-md-6 col-sm-6">
                    <label for="txtCantidad">Cantidad</label>
                    <asp:TextBox ID="txtCantidad" runat="server" class="form-control" placeholder="Cantidad"></asp:TextBox>
                </div>
                 </div>
        </div>

        <div class="card-footer">

            <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
            <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />

        </div>

    </div>

        <!-- /.card-body -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Listado de Ingresos</h3>
            </div>
            <!-- /.card-header -->
            <div class="card-body">
                <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" AllowSorting="True" OnDataBound="dtgPrincipal_DataBound" OnRowCommand ="dtgPrincipal_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                        <asp:BoundField DataField="IdRecepcion" HeaderText="IdRecepcion" Visible="false" />
                        <asp:BoundField DataField="Producto" HeaderText="Producto / Herramienta" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" >
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nombre" HeaderText="Unidad"  />
                        <asp:BoundField DataField="FechaVcto" HeaderText="Fecha Vcto." DataFormatString="{0:d}" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination pagination-sm float-right" />
                </asp:GridView>
            </div>
        </div>
</asp:Content>