<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="PrograActividadesCons.aspx.cs" Inherits="WEB.PrograActividadesCons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Consulta de Actividades Programadas</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Consulta de actividades programadas</li>
        </ol>
    </div>

    <script>
  $(function () {
    $("#<%= dtgPrincipal.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false,
      "searching": false,
      "ordering": true,
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
            <h3 class="card-title">Filtros</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
        <div class="card-body">

            <div class="row">
                
            <div class="form-group col-md-4 col-sm-4">
                <label for="ddlTemporada">Temporada</label>
                <asp:DropDownList ID="ddlTemporada" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>

            </div>
            <div class="form-group col-md-4 col-sm-4">
                <label for="ddlEnsayo">Ensayo</label>
                <asp:DropDownList ID="ddlEnsayo" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Codigo"></asp:DropDownList>

            </div>
            <div class="form-group col-md-4 col-sm-4">
                <label for="ddlLugar">Lugar</label>
                <asp:DropDownList ID="ddlLugar" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
            </div>
                </div>
            
            <div class="row">

            <div class="form-group col-md-4 col-sm-4">
                <label for="ddlEspecie">Especie</label>
                <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="Nombre"></asp:DropDownList>
            </div> 
                
            <div class="form-group col-md-4 col-sm-4">
                <label for="ddlResponsable">Responsable</label>
                <asp:DropDownList ID="ddlResponsable" runat="server" CssClass="form-control select2 select2-container select2-container--default" DataValueField="Id" DataTextField="nombre_empleado"></asp:DropDownList>
            </div>
                
            <div class="form-group col-md-4 col-sm-4">
                <label for="txtActividad">Actividad</label>
                <asp:TextBox ID="txtActividad" CssClass="form-control" runat="server"></asp:TextBox>
            </div>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            <asp:Button ID="btnFiltrar" runat="server" class="btn btn-info" Text="Filtrar" OnClick="btnFiltrar_Click" />
        </div>

    </div>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Actividades Programadas</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID,IdProgramacion" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" OnRowCommand="dtgPrincipal_RowCommand" AllowSorting="True" OnDataBound="dtgPrincipal_DataBound" OnRowCreated="dtgPrincipal_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                    <asp:BoundField DataField="Temporada" HeaderText="Temporada" ></asp:BoundField>
                    <asp:BoundField DataField="FechaDia" DataFormatString="{0:d}" HeaderText="Fecha">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                    <asp:BoundField DataField="Ensayo" HeaderText="Ensayo" />
                    <asp:BoundField DataField="DDS" HeaderText="DDS" />
                    <asp:BoundField DataField="Lugar" HeaderText="Lugar" />
                    <asp:BoundField DataField="Responsable" HeaderText="Responsable" />
                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                    <asp:BoundField DataField="ProdProgra" HeaderText="Productos" />
                    <asp:BoundField DataField="HerrProgra" HeaderText="Herramientas" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Ver" CommandName="Modificar" CommandArgument='<%#Eval("Id") + "," + Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField> 
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
</asp:Content>
