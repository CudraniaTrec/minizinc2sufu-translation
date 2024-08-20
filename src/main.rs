mod utils;
mod model;
fn main() {
    let tree=utils::parse_minizinc_file("test.mzn");
    // utils::print_all_node_kind(&tree.root_node());
    let model = utils::visit_source_file(&tree.root_node());
    println!("{}",model);
}

//test all the benchmarks under *_methyl *_synmem folders
#[cfg(test)]
mod tests {
    use std::path::Path;
    use walkdir::WalkDir;
    #[test]
    fn test_all_benchmarks() {
        let methyl_dir = Path::new("benchmarks_methyl");
        let synmem_dir = Path::new("benchmarks_synmem");
        // only files ends with .mzn
        let methyl_files = WalkDir::new(methyl_dir)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_file() && (e.path().extension().unwrap() == "mzn"))
            .map(|e| e.path().to_path_buf())
            .collect::<Vec<_>>();
        let synmem_files = WalkDir::new(synmem_dir)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_file() && (e.path().extension().unwrap() == "mzn"))
            .map(|e| e.path().to_path_buf())
            .collect::<Vec<_>>();
        let all_files = synmem_files.iter().chain(methyl_files.iter());
        for file in all_files {
            let file_name = file.file_name().unwrap().to_str().unwrap();
            println!("Parsing file: {}", file_name);
            let file_path = file.to_str().unwrap();
            let tree = super::utils::parse_minizinc_file(file_path);
            let model = super::utils::visit_source_file(&tree.root_node());
            // println!("{}", model);
        }
    }
}