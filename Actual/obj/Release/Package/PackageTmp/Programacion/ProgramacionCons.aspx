<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="ProgramacionCons.aspx.cs" Inherits="WEB.ProgramacionCons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Consulta de Ensayos Programados</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Consulta de ensayos programados</li>
        </ol>
    </div>

    <script>
  $(function () {
    $("#<%= dtgPrincipal.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false,
      "searching": false
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
            <h3 class="card-title">Lista de ensayos programados</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" DataKeyNames="ID" role="grid" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgPrincipal_PageIndexChanging" OnSorting="dtgPrincipal_Sorting" OnRowCommand="dtgPrincipal_RowCommand" AllowSorting="True" OnDataBound="dtgPrincipal_DataBound">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                    <asp:BoundField DataField="Temporada" HeaderText="Temporada" />
                    <asp:BoundField DataField="CodEnsayo" HeaderText="Ensayo" />
                    <asp:BoundField DataField="CodEspecie" HeaderText="Especie" />
                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                    <asp:BoundField DataField="Responsable" HeaderText="Responsable" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Ver" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField> 
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
</asp:Content>
