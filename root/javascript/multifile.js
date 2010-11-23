function MultiSelector( list_target, max ){
	this.list_target = list_target;
	this.count = 0;
	this.id = 0;
	if(max)	{	this.max = max; } 
	else 	{	this.max = -1;	}
	
	this.addElement = function( element ){
		if( element.tagName == 'INPUT' && element.type == 'file' ){
			element.name = 'file_' + this.id++;
			element.multi_selector = this;
			element.onchange = function(){
				var new_element = document.createElement( 'input' );
				new_element.type = 'file';
				this.parentNode.insertBefore( new_element, this );
				this.multi_selector.addElement( new_element );
				this.multi_selector.addListRow( this );
				this.style.position = 'absolute';
				this.style.left = '-1000px';
			};
			if( this.max != -1 && this.count >= this.max ){
				element.disabled = true;
			};
			this.count++;
			this.current_element = element;
		}
		else {	alert( 'Error: not a file input element' );	};
	};

	this.addListRow = function( element ){
		var new_row = document.createElement( 'tr' );
		new_row.className = 'upload_row';
		var new_row_button = document.createElement( 'input' );
new_row_button.className = 'new_row_button';
		new_row_button.type = 'button';
		new_row_button.value = 'Delete';
	//	var new_row_del_link = document.createElement('a');
	//	new_row_del_link.innerHTML = 'Delete';
	//	new_row_del_link.setAttribute('href','#');
	//	new_row_del_link.setAttribute('onClick','javascript:function(){ this.parentNode.element.parentNode.removeChild(this.parentNode.element);alert(\'passou\');this.parentNode.parentNode.removeChild( this.parentNode );this.parentNode.element.multi_selector.count--;this.parentNode.element.multi_selector.current_element.disabled = false;}');

		new_row.element = element;
		new_row_button.onclick= function(){
			this.parentNode.parentNode.element.parentNode.removeChild( this.parentNode.parentNode.element ); 	// remove element from form
		//	this.parentNode.element.parentNode.removeChild( this.parentNode.element ); 	// remove element from form

		//	this.parentNode.parentNode.removeChild( this.parentNode );					// remove row from list
			this.parentNode.parentNode.parentNode.removeChild( this.parentNode.parentNode ); 	// remove row from table

			this.parentNode.element.multi_selector.count--;								// decrement counter
			this.parentNode.element.multi_selector.current_element.disabled = false;	// re-enable input element
			return false;
		};

		new_row.innerHTML = '<td class="filename_'+this.id+'">'+element.value+'</td>';
		var row_button_td = document.createElement('td');
		row_button_td.appendChild(new_row_button );
		new_row_button.className = 'del_button';
		row_button_td.className = 'del_td';
		
		new_row.appendChild(row_button_td); 
	//	new_row.appendChild( new_row_del_link);
		this.list_target.appendChild( new_row );
		
	};

};
