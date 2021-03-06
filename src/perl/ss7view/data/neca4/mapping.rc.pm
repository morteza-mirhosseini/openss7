package mapping;

our %necarg = (
	'ALABAMA'=>'AL',
	'ALASKA'=>'AK',
	'AMERICAN SAMOA'=>'AS',
	'ARIZONA'=>'AZ',
	'ARKANSAS'=>'AR',
	'CALIFORNIA'=>'CA',
	'COLORADO'=>'CO',
	'CONNECTICUT'=>'CT',
	'DELAWARE'=>'DE',
	'DISTRICT OF COLUMBIA'=>'DC',
	'FLORIDA'=>'FL',
	'GEORGIA'=>'GA',
	'GUAM'=>'GU',
	'HAWAII'=>'HI',
	'IDAHO'=>'ID',
	'ILLINOIS'=>'IL',
	'INDIANA'=>'IN',
	'IOWA'=>'IA',
	'KANSAS'=>'KS',
	'KENTUCKY'=>'KY',
	'LOUISIANA'=>'LA',
	'MAINE'=>'ME',
	'MARYLAND'=>'MD',
	'MASSACHUSETTS'=>'MA',
	'MICHIGAN'=>'MI',
	'MINNESOTA'=>'MN',
	'MISSISSIPPI'=>'MS',
	'MISSOURI'=>'MO',
	'MONTANA'=>'MT',
	'NEBRASKA'=>'NE',
	'NEVADA'=>'NV',
	'NEW HAMPSHIRE'=>'NH',
	'NEW JERSEY'=>'NJ',
	'NEW MEXICO'=>'NM',
	'NEW YORK'=>'NY',
	'NORTH CAROLINA'=>'NC',
	'NORTH DAKOTA'=>'ND',
	'OHIO'=>'OH',
	'OKLAHOMA'=>'OK',
	'OREGON'=>'OR',
	'PENNSYLVANIA'=>'PA',
	'PUERTO RICO'=>'PR',
	'RHODE ISLAND'=>'RI',
	'SOUTH CAROLINA'=>'SC',
	'SOUTH DAKOTA'=>'SD',
	'TENNESSEE'=>'TN',
	'TEXAS'=>'TX',
	'UTAH'=>'UT',
	'VERMONT'=>'VT',
	'VIRGINIA'=>'VA',
	'VIRGIN ISLANDS'=>'VI',
	'WASHINGTON'=>'WA',
	'WEST VIRGINIA'=>'WV',
	'WISCONSIN'=>'WI',
	'WYOMING'=>'WY',
);

our %necast = (
	'AL'=>'ALABAMA',
	'AK'=>'ALASKA',
	'AS'=>'AMERICAN SAMOA',
	'AZ'=>'ARIZONA',
	'AR'=>'ARKANSAS',
	'CA'=>'CALIFORNIA',
	'CO'=>'COLORADO',
	'CT'=>'CONNECTICUT',
	'DE'=>'DELAWARE',
	'DC'=>'DISTRICT OF COLUMBIA',
	'FL'=>'FLORIDA',
	'GA'=>'GEORGIA',
	'GU'=>'GUAM',
	'HI'=>'HAWAII',
	'ID'=>'IDAHO',
	'IL'=>'ILLINOIS',
	'IN'=>'INDIANA',
	'IA'=>'IOWA',
	'KS'=>'KANSAS',
	'KY'=>'KENTUCKY',
	'LA'=>'LOUISIANA',
	'ME'=>'MAINE',
	'MD'=>'MARYLAND',
	'MA'=>'MASSACHUSETTS',
	'MI'=>'MICHIGAN',
	'MN'=>'MINNESOTA',
	'MS'=>'MISSISSIPPI',
	'MO'=>'MISSOURI',
	'MT'=>'MONTANA',
	'NE'=>'NEBRASKA',
	'NV'=>'NEVADA',
	'NH'=>'NEW HAMPSHIRE',
	'NJ'=>'NEW JERSEY',
	'NM'=>'NEW MEXICO',
	'NY'=>'NEW YORK',
	'NC'=>'NORTH CAROLINA',
	'ND'=>'NORTH DAKOTA',
	'OH'=>'OHIO',
	'OK'=>'OKLAHOMA',
	'OR'=>'OREGON',
	'PA'=>'PENNSYLVANIA',
	'PR'=>'PUERTO RICO',
	'RI'=>'RHODE ISLAND',
	'SC'=>'SOUTH CAROLINA',
	'SD'=>'SOUTH DAKOTA',
	'TN'=>'TENNESSEE',
	'TX'=>'TEXAS',
	'UT'=>'UTAH',
	'VT'=>'VERMONT',
	'VA'=>'VIRGINIA',
	'VI'=>'VIRGIN ISLANDS',
	'WA'=>'WASHINGTON',
	'WV'=>'WEST VIRGINIA',
	'WI'=>'WISCONSIN',
	'WY'=>'WYOMING',
);

our %mapping = (
	'NPA'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'NXX'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'X'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'rng'=>sub{
	},
	'lines'=>sub{
	},
	'total'=>sub{
	},
	'loc'=>sub{
		my ($dat,$fld,$val) = @_;
		if (length($val)) {
			$dat->{NAME} = $val;
			$dat->{RCSHORT} = substr("\U$val\E",0,10) if length($val)<=10;
			$dat->{RCNAME} = $val if not $dat->{RCSHORT} or $val =~ /[a-z]/;
		}
	},
	'state'=>sub{
		my ($dat,$fld,$val) = @_;
		my ($cc,$st,$rg,$pc,$ps) = ::getnxxccst($dat);
		if ($rg) {
			$dat->{REGION} = $rg;
			$dat->{RCCC} = $cc;
			$dat->{RCST} = $st;
			if (length($val)) {
				if (exists $necarg{$val}) {
					if ($rg ne $necarg{$val}) {
						if (exists $necast{$rg}) {
							::correct($dat,$fld,$val,$necast{$rg},'autocorrect by NPA-NXX');
						}
					}
				} else {
					::correct($dat,$fld,$val,$val,'FIXME: bad state');
				}
			} else {
				if (exists $necast{$rg}) {
					::correct($dat,$fld,$val,$necast{$rg},'autocorrect by NPA-NXX');
				}
			}
		} elsif (length($val)) {
			$dat->{"\U$fld\E"} = $val;
			if (exists $necarg{$val}) {
				$rg = $necarg{$val};
				if (exists $::lergcc{$rg} and exists $::lergst{$rg}) {
					$dat->{REGION} = $rg;
					$cc = $dat->{RCCC} = $::lergcc{$rg};
					$st = $dat->{RCST} = $::lergst{$rg};
				} else {
					::correct($dat,$fld,$val,$val,'FIXME: bad state');
				}
			} else {
				::correct($dat,$fld,$val,$val,'FIXME: bad state');
			}
		}
	},
	'clli'=>sub{
		my ($dat,$fld,$val) = @_;
		if ($val and length($val) == 11) {
			my $pfx = "$dat->{NPA}-$dat->{NXX}($dat->{X}):";
			my $result = ::checkclli($val,$pfx,$dat);
			::correct($dat,$fld,$val,$val,$dat->{BADCLLI}) if $dat->{BADCLLI};
			return unless $result;
			$dat->{SWCLLI} = $val;
			$dat->{WCCLLI} = substr($val,0,8);
			$dat->{PLCLLI} = substr($val,0,6);
			$dat->{CTCLLI} = substr($val,0,4);
			my $cs = $dat->{STCLLI} = substr($val,4,2);
			$dat->{WCCC} = $::cllicc{$cs} if exists $::cllicc{$cs};
			$dat->{WCST} = $::cllist{$cs} if exists $::cllist{$cs};
			$dat->{WCRG} = $::cllirg{$cs} if exists $::cllirg{$cs};
			print STDERR "E: $pfx CLLI $val: no CC for CLLI region $cs\n" unless exists $::cllicc{$cs};
			print STDERR "E: $pfx CLLI $val: no ST for CLLI region $cs\n" unless exists $::cllist{$cs};
			print STDERR "E: $pfx CLLI $val: no RG for CLLI region $cs\n" unless exists $::cllirg{$cs};
		}
	},
	'wcvh'=>sub{
		my ($dat,$fld,$val) = @_;
		if (length($val)) {
			my ($v,$h) = split(/,/,$val);
			if ($v and $h) {
				$dat->{VH} = $dat->{WCVH} = sprintf('%05d,%05d',$v,$h);
				$dat->{LL} = $dat->{WCLL} = join(',',::vh2ll($v,$h));
			}
		}
	},
	'ocn'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'lata'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'feat'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
	'sect'=>sub{
		my ($dat,$fld,$val) = @_;
		$dat->{"\U$fld\E"} = $val if length($val);
	},
);
