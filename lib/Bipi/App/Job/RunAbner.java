import abner.*;
import java.io.*;

public class RunAbner{

	Tagger t;

	public RunAbner(){
		t = new Tagger();
	}

	public String tag(String text){
		return t.tagSGML(text);
	}

	public static void main(String[] args){
		if(args.length == 0){ System.out.println("Usage: java RunAbner filepath"); return; }
		RunAbner ma = new RunAbner();
		StringBuilder sb = new StringBuilder();
		try {
			BufferedReader br = new BufferedReader(new FileReader(args[0]));
			String line=null,text=null;
			while((line = br.readLine()) != null)
				text+=line;
			System.out.println(ma.tag(text));	
		} catch (IOException e){ System.out.println("File "+args[0]+" not found.");}
	}
}
