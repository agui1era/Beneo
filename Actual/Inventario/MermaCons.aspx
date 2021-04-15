<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="MermaCons.aspx.cs" Inherits="WEB.MermaCons"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Consulta de Mermas</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Consulta de Merma</li>
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
                    <label for="ddlHerramienta">Herramienta</label>
                    <asp:DropDownList ID="ddlHerramienta" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="IdHerramienta" DataTextField="Nombre"></asp:DropDownList>
                </div>  
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlMotivo">Motivo</label>
                    <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Motivo"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-4 col-sm-4">
                    <label for="ddlUsuarioCrea">Usuario</label>
                    <asp:DropDownList ID="ddlUsuarioCrea" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
                </div>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />
            <%--<asp:Button ID="btnNuevo" runat="server" class="btn btn-success" Text="Nuevo" OnClick="btnNuevo_Click"  />--%>
        <asp:Button ID="btnCrear" class="btn btn-success" runat="server" Text="Nuevo" CommandName="Nuevo" OnClick="btnCrear_Click"></asp:Button>
        </div>
        

    </div>
    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title" >Lista de Mermas</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="2500"  AllowSorting="True" OnDataBound="dtgPrincipal_DataBound" OnRowCreated="dtgPrincipal_RowCreated" OnRowDataBound="dtgPrincipal_RowDataBound">
                <Columns>              
                    <asp:BoundField DataField="Id" HeaderText="Id" visible="false"/>
                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                    <asp:BoundField DataField="Observacion" HeaderText="Observación" />
                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Nombre" HeaderText="Usuario Crea" />
                    <asp:BoundField DataField="FechaCrea" HeaderText="Fecha Crea" DataFormatString="{0:g}" />
                    <asp:BoundField DataField="Motivo" HeaderText="Motivo" />   
                 <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") + "," + Eval("Id") %>' OnClick="btnModificar_Click"></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnEliminar" class="btn btn-success" runat="server" Text="Eliminar" CommandName="Eliminar" CommandArgument='<%#Eval("Id") + "," + Eval("Id") %>' OnClick="btnEliminar_Click"></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField> 
                   
                </Columns>
              </asp:GridView>
         </div>
        <!-- /.card-body -->
    </div>
  

        <div class="modal fade" runat="server"  id="miModalIns" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">Ingreso Merma</h4>
                    </div>
                    <div class="modal-body">
                     <div class="card-body">
                <div class="row">
                    <div class="form-group col-md-4 col-sm-4">
                            <label for=""></label>
                            <asp:TextBox ID="Id" name="txtFecha" runat="server" class="form-control" placeholde="" Visible="false" autocomplete="off"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4 col-sm-4">
                            <label for="txtFecha">Fecha</label>
                            <asp:TextBox ID="txtFecha" name="txtFecha" runat="server" class="form-control" placeholde="" autocomplete="off"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4 col-sm-4">
                            <label for="txtObservacion">Observacion</label>
                            <asp:TextBox ID="txtObservacion" name="txtObservacion" runat="server" class="form-control" placeholde="" autocomplete="off"></asp:TextBox>
                        </div>
                        <div class="form-group col-md-4 col-sm-4">
                            <label for="ddlMotivoIns">Motivo</label>
                            <asp:dropdownlist ID="ddlMotivoIns" name="ddlMotivoIns" runat="server" class="form-control" placeholde="" autocomplete="off"></asp:dropdownlist>
                        </div>
                        <div class="form-group col-md-4 col-sm-4">
                            <label for="ddlProductoIns">Producto</label>
                            <asp:dropdownlist ID="ddlProductoIns" name="ddlProductoIns" runat="server" class="form-control" placeholde="" autocomplete="off"></asp:dropdownlist>
                        </div>
                    </div>
                         <asp:Button ID="btnGuardarModal" runat="server" class="btn btn-primary" Text="Guardar" onClick="btnGuardarModal_Click"/>
                
                    
            </div>
                      </div>
                </div>
            </div>
        </div>
    
                
</asp:Content>
