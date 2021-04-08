let g:quickrun_known_file_types = {
        \"cpp": ["!g++ %", "./a.out"],
        \"c": ["!gcc %", "./a.out"],
        \"php": ["!php %"],
        \"vim": ["source %"],
        \"py": ["!python %"],
        \"go": ["!go test"],
        \"jsx": ["node run dev"],
        \"tsx": ["node run dev"],
    \}
